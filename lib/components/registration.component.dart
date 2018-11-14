import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mobile/services/profile.service.dart';
import 'package:mobile/util/snackbar.util.dart';


class RegistrationComponent extends StatefulWidget {
    RegistrationComponent() : super();

    @override
    _RegistrationComponentState createState() => new _RegistrationComponentState();
}

class _RegistrationComponentState extends State<RegistrationComponent> {
    String _username;
    String _password;
    String _displayname;

    ProfileService profileService = new ProfileService();

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Register"),
            ),
            body: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        this._buildColumn(
                            new TextField(
                                decoration: new InputDecoration(
                                    hintText: "Username"
                                ),
                                onChanged: (value) => this._username = value,
                            )
                        ),
                        this._buildColumn(
                            new TextField(
                                decoration: new InputDecoration(
                                    hintText: "Password"
                                ),
                                onChanged: (value) => this._password = value,
                            )
                        ),
                        this._buildColumn(
                            new TextField(
                                decoration: new InputDecoration(
                                    hintText: "Display Name"
                                ),
                                onChanged: (value) => this._displayname = value,
                            )
                        ),
                        this._buildColumn(
                            new Builder(builder: (BuildContext context) {
                                return new RaisedButton(
                                    child: new Text(
                                        "Submit",
                                        style: new TextStyle(
                                            color: Colors.white
                                        )
                                    ),
                                    color: Theme.of(context).accentColor,
                                    onPressed: () => _handleSubmit(context),
                                );
                            }),
                        ),
                    ],
                ),
            ),
        );
    }

    Widget _buildColumn(Widget w) {
        return new Container(
            padding: new EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
            ),
            child: w,
        );
    }

    void _handleSubmit(BuildContext context) {
        DateTime now = new DateTime.now();
        profileService.createProfile(this._username, this._password, this._displayname, now).then(
            (success) => success
                ? this._handleSuccess(context)
                : this._handleFailure(context)
        );
    }

    void _handleSuccess(BuildContext context) {
        showSuccessSnackBar(context, "profile successfully created");
        new Timer(
            const Duration(
                seconds: 1, milliseconds: 500
            ),
            () => Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false)
        );
    }

    void _handleFailure(BuildContext context) {
        showFailureSnackBar(context, "failed to register profile");
    }
}
