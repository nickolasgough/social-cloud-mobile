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
    String _connection;

    ProfileService _profileService = new ProfileService();
    ConnectionService _connectionService = new ConnectionService();

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Connection"),
            ),
            body: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        this._buildColumn(
                            new Container(
                                child: new TextField(
                                    decoration: new InputDecoration(
                                        hintText: "Enter connection",
                                        contentPadding: new EdgeInsets.all(10.0),
                                        border: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    onChanged: (String value) => this._connection= value,
                                ),
                                decoration: new BoxDecoration(
                                    border: new Border.all(
                                        color: Theme.of(context).accentColor,
                                    ),
                                    borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                                ),
                            ),
                        ),
                    ],
                ),
            ),
            floatingActionButton: new Builder(
                builder: (BuildContext context) {
                    return new FloatingActionButton(
                        child: new Icon(Icons.send),
                        onPressed: () => this._requestConnection(context),
                    );
                }
            ),
        );
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

    void _requestConnection(context) {
        String username = this._profileService.getUsername();
        DateTime now = new DateTime.now();
        this._connectionService.requestConnection(this._connection, username, now).then(
                (success) => success
                ? this._handleSuccess(context)
                : this._handleFailure(context)
        );
    }

    void _handleSuccess(BuildContext context) {
        showSuccessSnackBar(context, "connection request sent");
        new Timer(const Duration(
            seconds: 1,
        ), () => Navigator.of(context).pop());
    }

    void _handleFailure(BuildContext context) {
        showFailureSnackBar(context, "failed to send request");
    }
}
