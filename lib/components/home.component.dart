import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/services/connection.service.dart';
import 'package:mobile/services/notification.service.dart';
import 'package:mobile/services/profile.service.dart';
import 'package:mobile/util/datetime.util.dart';
import 'package:mobile/util/snackbar.util.dart';


class HomeComponent extends StatefulWidget {
    HomeComponent() : super();

    @override
    _HomeComponentState createState() => new _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
    ProfileService _profileService = new ProfileService();
    NotificationService _notificationService = new NotificationService();
    ConnectionService _connectionService = new ConnectionService();

    Future<List<Notice>> _notices;

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Home"),
            ),
            body: new Builder(
                builder: this._scaffoldBuilder,
            ),
            floatingActionButton: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                    this._buildButton(new FloatingActionButton(
                        child: new Icon(Icons.person_add),
                        onPressed: () => this._addConnection(context),
                        heroTag: "add-connection",
                    )),
                    this._buildButton(new FloatingActionButton(
                        child: new Icon(Icons.group_add),
                        onPressed: () => this._createGroup(context),
                        heroTag: "add-group",
                    )),
                    this._buildButton(new FloatingActionButton(
                        child: new Icon(Icons.edit),
                        onPressed: () => this._createPost(context),
                        heroTag: "create-post",
                    )),
                ],
            ),
        );
    }

    Widget _scaffoldBuilder(BuildContext context) {
        this._notices = this._listNotifications();

        return new FutureBuilder(
            future: this._notices,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                    return _buildNotifications(context, snapshot.data as List<Notice>);
                } else {
                    return new Center(
                        child: new CircularProgressIndicator(),
                    );
                }
            },
        );
    }

    Widget _buildColumn(Widget w) {
        return new Container(
            padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: w,
        );
    }

    Widget _buildButton(FloatingActionButton b) {
        return new Container(
            padding: new EdgeInsets.only(top: 10.0),
            child: b,
        );
    }

    Future<List<Notice>> _listNotifications() async {
        String username = this._profileService.getUsername();
        return this._notificationService.listNotices(username);
    }

    Widget _buildNotifications(BuildContext context, List<Notice> notices) {
        List<Widget> children = new List<Widget>();
        for (Notice notice in notices) {
            if (notice.type == "connection-request") {
                children.add(_buildConnection(context, notice));
            } else {
                children.add(_buildNotification(context, notice));
            }
        }

        return new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: children,
        );
    }

    Widget _buildConnection(BuildContext context, Notice notice) {
        String sender = notice.sender;
        String datetime = shortTime(notice.datetime);

        Card card = new Card(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.person_add),
                        title: new Text("Connection Request"),
                        subtitle: new Text(datetime),
                    ),
                    this._buildBody(new Text("$sender requested to connect with you")),
                    new ButtonTheme.bar(
                        child: new ButtonBar(
                            children: <Widget>[
                                new FlatButton(
                                    onPressed: () => this._declineConnection(context, notice),
                                    child: new Text("DECLINE"),
                                ),
                                new FlatButton(
                                    onPressed: () => this._acceptConnection(context, notice),
                                    child: new Text("ACCEPT"),
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );

        return this._buildColumn(card);
    }

    void _acceptConnection(BuildContext context, Notice notice) {
        String username = this._profileService.getUsername();
        DateTime now = new DateTime.now();
        this._connectionService.acceptConnection(username, notice.sender, now).then(
            (success) => success
                ? this._handleSuccess(context, "connection request accepted")
                : this._handleFailure(context, "connection request not accepted")
        );
    }

    void _declineConnection(BuildContext context, Notice notice) {
        String username = this._profileService.getUsername();
        DateTime now = new DateTime.now();
        this._connectionService.declineConnection(username, notice.sender, now).then(
                (success) => success
                ? this._handleSuccess(context, "connection request declined")
                : this._handleFailure(context, "connection request not declined")
        );
    }

    Widget _buildNotification(BuildContext context, Notice notice) {
        String sender = notice.sender;
        String datetime = shortTime(notice.datetime);

        Card card = new Card(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.person_add),
                        title: this._notificationTitle(notice),
                        subtitle: new Text(datetime),
                    ),
                    this._buildBody(this._notificationBody(notice)),
                    new ButtonTheme.bar(
                        child: new ButtonBar(
                            children: <Widget>[
                                new FlatButton(
                                    onPressed: () => _dismissNotification(context, notice),
                                    child: new Text("DISMISS"),
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );

        return this._buildColumn(card);
    }

    Widget _notificationTitle(Notice notice) {
        String title;

        switch (notice.type) {
            case "connection-accepted":
                title = "Connection Accepted";
                break;
        }

        return new Text(title);
    }

    Widget _notificationBody(Notice notice) {
        String body;
        String sender = notice.sender;

        switch (notice.type) {
            case "connection-accepted":
                body = "$sender accepted your connection request";
                break;
        }

        return new Text(body);
    }

    void _dismissNotification(BuildContext context, Notice notice) {
        this._notificationService.dismissNotice(notice.username, notice.sender, notice.datetime).then(
            (success) => success
                ? this._handleSuccess(context, "notifcation successfully dismis")
                : this._handleFailure(context, "failed to dismiss notification")
        );
    }

    Widget _buildBody(Widget w) {
        return new Container(
            padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: w,
        );
    }

    void _handleSuccess(BuildContext context, String message) {
        showSuccessSnackBar(context, message);
        this.setState(() {
            this._notices = this._listNotifications();
        });
    }

    void _handleFailure(BuildContext context, String message) {
        showFailureSnackBar(context, message);
    }

    void _addConnection(BuildContext context) {
        Navigator.of(context).pushNamed("/connection/add");
    }

    void _createGroup(BuildContext context) {
        Navigator.of(context).pushNamed("/group/create");
    }

    void _createPost(BuildContext context) {
        Navigator.of(context).pushNamed("/post/compose");
    }
}
