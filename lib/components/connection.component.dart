import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mobile/services/connection.service.dart';
import 'package:mobile/services/profile.service.dart';
import 'package:mobile/util/snackbar.util.dart';


class ConnectionComponent extends StatefulWidget {
    ConnectionComponent() : super();

    @override
    _ConnectionComponentState createState() => new _ConnectionComponentState();
}

class _ConnectionComponentState extends State<ConnectionComponent> {
    ProfileService _profileService = new ProfileService();
    ConnectionService _connectionService = new ConnectionService();

    String _query;
    Future<List<User>> _users;

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Connection"),
            ),
            body: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                    this._buildColumn(
                        new Container(
                            child: new TextField(
                                decoration: new InputDecoration(
                                    labelText: "Search",
                                    hintText: "Search",
                                    contentPadding: new EdgeInsets.all(10.0),
                                    border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.multiline,
                                onChanged: (String value) => this._query = value,
                            ),
                            decoration: new BoxDecoration(
                                border: new Border.all(
                                    color: Theme.of(context).accentColor,
                                ),
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(10.0),
                                ),
                            ),
                        ),
                    ),
                    new FutureBuilder(
                        initialData: new List<User>(),
                        future: this._users,
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                                return new Container(
                                    height: 200.0,
                                    child: this._buildColumn(
                                        this._buildUsers(context, snapshot.data as List<User>)
                                    ),
                                );
                            } else {
                                return new Center(
                                    child: new CircularProgressIndicator(),
                                );
                            }
                        }
                    ),
                ],
            ),
            floatingActionButton: new Builder(
                builder: (BuildContext context) {
                    return new FloatingActionButton(
                        child: new Icon(Icons.search),
                        onPressed: this._searchUsers,
                    );
                }
            ),
        );
    }

    Widget _buildColumn(Widget w) {
        return new Container(
            child: w,
            padding: new EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 50.0,
            ),
        );
    }

    Widget _buildUsers(BuildContext context, List<User> users) {
        List<ListTile> children = new List<ListTile>();
        for (User user in users) {
            children.add(new ListTile(
                leading: this._buildAvatar(user.imageurl),
                title: new Text(user.displayname),
                trailing: !user.connected
                    ? new IconButton(
                        icon: new Icon(Icons.person_add),
                        onPressed: () => this._requestConnection(context, user)
                    ) : null,
            ));
        }

        return new ListView(
            children: children,
            padding: new EdgeInsets.only(
                bottom: 70.0,
            ),
        );
    }

    Widget _buildAvatar(String imageurl) {
        if (imageurl == null || imageurl.isEmpty) {
            return new Container(
                child: new Icon(
                    Icons.person,
                    size: 30.0,
                ),
                height: 30.0,
                width: 30.0,
                decoration: new BoxDecoration(
                    border: new Border.all(
                        color: Theme.of(context).accentColor,
                    ),
                    borderRadius: new BorderRadius.all(
                        new Radius.circular(15.0),
                    ),
                ),
            );
        }

        return new Container(
            height: 30.0,
            width: 30.0,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new NetworkImage(imageurl),
                    fit: BoxFit.contain,
                ),
                border: new Border.all(
                    color: Theme.of(context).accentColor,
                ),
                borderRadius: new BorderRadius.all(
                    new Radius.circular(15.0),
                ),
            ),
        );
    }

    void _searchUsers() {
        this.setState(() {
            this._users = this._profileService.searchUsers(this._query);
        });
    }

    void _requestConnection(BuildContext context, User user) {
        String email = this._profileService.getEmail();
        DateTime now = new DateTime.now();
        this._connectionService.requestConnection(user.email, email, now).then(
                (success) {
                    if (success) {
                        this.setState(() => user.connected = true);
                        this._handleSuccess(context);
                    } else {
                        this._handleFailure(context);
                    }
                }
        );
    }

    void _handleSuccess(BuildContext context) {
        showSuccessSnackBar(context, "connection request sent");
    }

    void _handleFailure(BuildContext context) {
        showFailureSnackBar(context, "failed to send request");
    }
}
