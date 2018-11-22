import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';


class StartupComponent extends StatefulWidget {
    StartupComponent() : super();

    @override
    _StartupComponentState createState() => new _StartupComponentState();
}

class _StartupComponentState extends State<StartupComponent> {
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
        this._googleSignIn.onCurrentUserChanged.listen(
            (user) => print(user)
        );
        try {
            this._googleSignIn.signIn();
        } catch (error) {
            print(error);
        }
    }
}
