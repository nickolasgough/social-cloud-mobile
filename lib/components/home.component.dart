import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/services/notification.service.dart';
import 'package:mobile/services/profile.service.dart';
import 'package:mobile/util/datetime.util.dart';


class HomeComponent extends StatefulWidget {
    HomeComponent() : super();

    @override
    _HomeComponentState createState() => new _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
    ProfileService _profileService = new ProfileService();
    NotificationService _notificationService = new NotificationService();

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Home"),
            ),
            body: new FutureBuilder(
                future: this._getNotifications(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                        return _buildNotifications(snapshot.data as List<Notice>);
                    } else {
                        return new CircularProgressIndicator();
                    }
                },
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
                        child: new Icon(Icons.edit),
                        onPressed: () => this._createPost(context),
                        heroTag: "create-post",
                    )),
                ],
            ),
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

    Future<List<Notice>> _getNotifications() async {
        String username = this._profileService.getUsername();
        return this._notificationService.listNotices(username);
    }

    Widget _buildNotifications(List<Notice> notices) {
        List<Widget> children = new List<Widget>();
        for (Notice notice in notices) {
            if (notice.type == "connection-request") {
                children.add(_buildConnection(notice));
            } else {
                children.add(_buildNotification(notice));
            }
        }

        return new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: children,
        );
    }

    Widget _buildBody(Widget w) {
        return new Container(
            padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: w,
        );
    }

    Widget _buildConnection(Notice notice) {
        String sender = notice.sender;
        String datetime = shortTime(notice.datetime);
        Card card = new Card(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.person_add),
                        title: new Text("Connection Request Received"),
                        subtitle: new Text("Somebody has requested to connect"),
                    ),
                    this._buildBody(new Text("$sender has requested to connect with you on $datetime")),
                    new ButtonTheme.bar(
                        child: new ButtonBar(
                            children: <Widget>[
                                new FlatButton(
                                    onPressed: _declineConnection,
                                    child: new Text("DECLINE"),
                                ),
                                new FlatButton(
                                    onPressed: _acceptConnection,
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

    void _acceptConnection() {}

    void _declineConnection() {}

    Widget _buildNotification(Notice notice) {
        String sender = notice.sender;
        String datetime = shortTime(notice.datetime);
        Card card = new Card(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.person_add),
                        title: new Text("Generic Notification received"),
                        subtitle: new Text("Generic Notification received"),
                    ),
                    this._buildBody(new Text("$sender sent you a generic notification on $datetime")),
                    new ButtonTheme.bar(
                        child: new ButtonBar(
                            children: <Widget>[
                                new FlatButton(
                                    onPressed: _acceptConnection,
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

    void _addConnection(BuildContext context) {
        Navigator.of(context).pushNamed("/connection/add");
    }

    void _createPost(BuildContext context) {
        Navigator.of(context).pushNamed("/post/compose");
    }
}
