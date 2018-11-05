import 'dart:async';

import 'package:flutter/material.dart';


class StartupComponent extends StatefulWidget {
    StartupComponent() : super();

    @override
    _StartupComponentState createState() => new _StartupComponentState();
}

class _StartupComponentState extends State<StartupComponent> {
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
                    ],
                ),
            ),
        );
    }

    Container _buildColumn(Widget w) {
        return new Container(
            padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: w,
        );
    }

    void _handleLogin(BuildContext context) {
        Navigator.of(context).pushNamed("/login");
    }

    void _handleRegister(BuildContext context) {
        Navigator.of(context).pushNamed("/register");
    }
}
