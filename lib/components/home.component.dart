import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/services/notification.service.dart';
import 'package:mobile/services/profile.service.dart';


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
                        return new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                new Text("No notifications")
                            ],
                        );
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

    Container _buildColumn(Widget w) {
        return new Container(
            padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: w,
        );
    }

    Container _buildButton(FloatingActionButton b) {
        return new Container(
            padding: new EdgeInsets.only(top: 10.0),
            child: b,
        );
    }

    Future<List<Notice>> _getNotifications() async {
        String username = this._profileService.getUsername();
        return this._notificationService.ListNotices(username);
    }

    void _addConnection(BuildContext context) {
        Navigator.of(context).pushNamed("/connection/add");
    }

    void _createPost(BuildContext context) {
        Navigator.of(context).pushNamed("/post/compose");
    }
}
