import 'package:flutter/material.dart';

import 'package:mobile/services/profile.service.dart';


class HomeComponent extends StatefulWidget {
    HomeComponent() : super();

    @override
    _HomeComponentState createState() => new _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
    String username;
    String password;
    String displayname;

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Home"),
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
                                onChanged: (value) => this.username = value,
                            )
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
}
