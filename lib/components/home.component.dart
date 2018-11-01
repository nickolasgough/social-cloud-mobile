import 'package:flutter/material.dart';

import 'package:mobile/services/profile.service.dart';


class HomeComponent extends StatefulWidget {
    HomeComponent() : super();

    @override
    _HomeComponentState createState() => new _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
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
                            new Text("Hello"),
                        ),
                    ],
                ),
            ),
            floatingActionButton: new FloatingActionButton(
                child: new Icon(Icons.edit),
                onPressed: () => _createPost(context),
            ),
        );
    }

    Container _buildColumn(Widget w) {
        return new Container(
            padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: w,
        );
    }

    void _createPost(BuildContext context) {
        Navigator.of(context).pushNamed("/post/compose");
    }
}
