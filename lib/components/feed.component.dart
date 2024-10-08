import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mobile/services/connection.service.dart';
import 'package:mobile/services/feed.service.dart';
import 'package:mobile/services/profile.service.dart';
import 'package:mobile/util/snackbar.util.dart';


class FeedComponent extends StatefulWidget {
    FeedComponent() : super();

    @override
    _FeedComponentState createState() => new _FeedComponentState();
}

class _FeedComponentState extends State<FeedComponent> {
    ProfileService _profileService = new ProfileService();
    ConnectionService _connectionService = new ConnectionService();
    FeedService _groupService = new FeedService();

    Future<List<Connection>> _connections;
    String _feedname;
    List<Connection> _members = new List<Connection>();

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Feed"),
            ),
            body: new Builder(
                builder: this._buildScaffold,
            ),
            floatingActionButton: new Builder(
                builder: (BuildContext context) {
                    return new FloatingActionButton(
                        child: new Icon(Icons.add),
                        onPressed: () => this._createFeed(context),
                    );
                }
            ),
        );
    }

    Widget _buildScaffold(BuildContext context) {
        this._connections = this._listConnections();

        return new FutureBuilder(
            future: this._connections,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                    return new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                            this._buildInput(),
                            this._buildConnections(context, snapshot.data as List<Connection>),
                        ],
                    );
                } else {
                    return new Center(
                        child: new CircularProgressIndicator(),
                    );
                }
            },
        );
    }

    Widget _buildInput() {
        Container container = new Container(
            child: new TextField(
                decoration: new InputDecoration(
                    hintText: "Enter name",
                    contentPadding: new EdgeInsets.all(10.0),
                    border: InputBorder.none,
                ),
                keyboardType: TextInputType.multiline,
                onChanged: (value) => this._feedname= value,
            ),
            decoration: new BoxDecoration(
                border: new Border.all(
                    color: Theme.of(context).accentColor,
                ),
                borderRadius: new BorderRadius.all(
                    new Radius.circular(10.0),
                ),
            ),
        );

        return this._buildColumn(container);
    }

    Widget _buildConnections(BuildContext context, List<Connection> connections) {
        List<CheckboxListTile> children = new List<CheckboxListTile>();

        for (int n = 0; n < connections.length; n += 1) {
            Connection connection = connections[n];
            children.add(new CheckboxListTile(
                title: new Row(
                    children: <Widget>[
                        this._buildAvatar(connection.imageurl),
                        new Container(
                            child: new Text(connection.displayname),
                            padding: new EdgeInsets.only(
                                left: 10.0,
                            ),
                        ),
                    ],
                ),
                value: this._isChecked(connection),
                onChanged: (value) => this._updateFeed(n, value, connection),
            ));
        }

        return new Expanded(
            child: this._buildColumn(
                new ListView(
                    children: children,
                )
            ),
        );
    }

    Widget _buildAvatar(String imageurl) {
        if (imageurl == null || imageurl.isEmpty) {
            return new Container(
                child: new Icon(
                    Icons.person,
                    size: 45.0,
                ),
                height: 45.0,
                width: 45.0,
                decoration: new BoxDecoration(
                    border: new Border.all(
                        color: Theme.of(context).accentColor,
                    ),
                    borderRadius: new BorderRadius.all(
                        new Radius.circular(22.5),
                    ),
                ),
            );
        }

        return new Container(
            height: 45.0,
            width: 45.0,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new NetworkImage(imageurl),
                    fit: BoxFit.contain,
                ),
                border: new Border.all(
                    color: Theme.of(context).accentColor,
                ),
                borderRadius: new BorderRadius.all(
                    new Radius.circular(22.5),
                ),
            ),
        );
    }

    bool _isChecked(Connection connection) {
        return this._members.firstWhere(
            (c) => c.connection == connection.connection,
            orElse: () => null
        ) != null;
    }

    void _updateFeed(int index, bool checked, Connection connection) {
        this.setState(() {
            if (checked) {
                this._members.add(connection);
            } else {
                this._members.removeWhere(
                    (c) => c.connection == connection.connection,
                );
            }
        });
    }

    Widget _buildColumn(Widget w) {
        return new Container(
            child: w,
            padding: new EdgeInsets.symmetric(
                vertical: 30.0,
                horizontal: 50.0,
            ),
        );
    }

    Future<List<Connection>> _listConnections() {
        String email = this._profileService.getEmail();
        return this._connectionService.listConnections(email);
    }

    void _createFeed(BuildContext context) {
        String email = this._profileService.getEmail();
        DateTime now = new DateTime.now();
        this._groupService.createFeed(email, this._feedname, this._members, now).then(
            (success) => success
                ? this._handleSuccess(context)
                : this._handleFailure(context)
        );
    }

    void _handleSuccess(BuildContext context) {
        showSuccessSnackBar(context, "feed successfully created");
        new Timer(const Duration(
            seconds: 1,
        ), () => Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false));
    }

    void _handleFailure(BuildContext context) {
        showFailureSnackBar(context, "failed to create feed");
    }
}
