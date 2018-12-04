import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/services/profile.service.dart';
import 'package:mobile/util/snackbar.util.dart';


class StartupComponent extends StatefulWidget {
    StartupComponent() : super();

    @override
    _StartupComponentState createState() => new _StartupComponentState();
}

class _StartupComponentState extends State<StartupComponent> {
    ProfileService _profileService = new ProfileService();

    GoogleSignIn _googleSignIn = new GoogleSignIn(
        scopes: [
            'email',
        ],
    );

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Social Cloud"),
            ),
            body: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        _buildColumn(
                            new Builder(builder: (BuildContext context) {
                                return new RaisedButton(
                                    child: new Text(
                                        "Login",
                                        style: new TextStyle(
                                            color: Colors.white
                                        )
                                    ),
                                    color: Theme.of(context).accentColor,
                                    onPressed: () => _handleLogin(context),
                                );
                            }),
                        ),
                        _buildColumn(
                            new Builder(builder: (BuildContext context) {
                                return new RaisedButton(
                                    child: new Text(
                                        "Register",
                                        style: new TextStyle(
                                            color: Colors.white
                                        )
                                    ),
                                    color: Theme.of(context).accentColor,
                                    onPressed: () => _handleRegister(context),
                                );
                            }),
                        ),
                        _buildColumn(new Text("or")),
                        new Builder(builder: (BuildContext context) {
                            return new RaisedButton(
                                child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                        new Image.asset(
                                            "assets/google.jpg",
                                            height: 35.0,
                                            width: 35.0,
                                        ),
                                        new Container(
                                            child: new Text(
                                                "Sign in with Google",
                                                style: new TextStyle(
                                                    color: Colors.white
                                                ),
                                            ),
                                            padding: new EdgeInsets.only(
                                                left: 10.0,
                                            ),
                                        ),
                                    ],
                                ),
                                color: Theme.of(context).accentColor,
                                onPressed: () => _handleGoogle(context),
                                padding: new EdgeInsets.symmetric(
                                    horizontal: 3.0,
                                ),
                            );
                        }),
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

    void _handleLogin(BuildContext context) {
        Navigator.of(context).pushNamed("/login");
    }

    void _handleRegister(BuildContext context) {
        Navigator.of(context).pushNamed("/register");
    }

    void _handleGoogle(BuildContext context) {
        try {
            this._googleSignIn.signIn().then(
                (account) {
                    if (account == null) {
                        showFailureSnackBar(context, "failed to sign in profile");
                        return;
                    }

                    DateTime datetime = new DateTime.now();
                    this._profileService.googleSignIn(account.email, account.displayName, account.photoUrl, datetime).then(
                        (success) {
                            if (success) {
                                showSuccessSnackBar(context, "profile sign in successful");
                                new Timer(const Duration(
                                    seconds: 1,
                                ), () => Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false));
                            } else {
                                showFailureSnackBar(context, "failed to sign in profile");
                            }
                        }
                    );
                }
            );
        } catch (error) {
            print(error);
        }
    }
}
