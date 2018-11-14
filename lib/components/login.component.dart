import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mobile/services/profile.service.dart';
import 'package:mobile/util/snackbar.util.dart';


class LoginComponent extends StatefulWidget {
    LoginComponent() : super();

    @override
    _LoginComponentState createState() => new _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
    String _username;
    String _password;

    ProfileService profileService = new ProfileService();

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Login"),
            ),
            body: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        _buildColumn(
                            new TextField(
                                decoration: new InputDecoration(
                                    hintText: "Username"
                                ),
                                onChanged: (value) => this._username = value,
                            )
                        ),
                        _buildColumn(
                            new TextField(
                                decoration: new InputDecoration(
                                    hintText: "Password"
                                ),
                                onChanged: (value) => this._password = value,
                            )
                        ),
                        _buildColumn(
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
        profileService.loginProfile(this._username, this._password).then(
                (success) => success
                ? this._handleSuccess(context)
                : this._handleFailure(context)
        );
    }

    void _handleSuccess(BuildContext context) {
        showSuccessSnackBar(context, "profile login successful");
        new Timer(
            const Duration(
                seconds: 1, milliseconds: 500
            ),
            () => Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false)
        );
    }

    void _handleFailure(BuildContext context) {
        showFailureSnackBar(context, "failed to login profile");
    }
}
