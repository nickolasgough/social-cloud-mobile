import 'package:flutter/material.dart';
import 'package:mobile/components/notification.component.dart';
import 'package:mobile/components/stream.component.dart';


class HomeComponent extends StatefulWidget {
    HomeComponent() : super();

    @override
    _HomeComponentState createState() => new _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
    @override
    Widget build(BuildContext context) {
        return new DefaultTabController(
            length: 2,
            child: new Scaffold(
                appBar: new AppBar(
                    title: new Text("Home"),
                    actions: <Widget>[
                        new PopupMenuButton<String>(
                            onSelected: (String path) => this._navigateTo(context, path),
                            itemBuilder: (BuildContext context) {
                                return <PopupMenuEntry<String>>[
                                    new PopupMenuItem<String>(
                                        value: "/profile/edit",
                                        child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                                new Icon(Icons.edit),
                                                this._buildColumn(new Text("Edit Profile")),
                                            ],
                                        ),
                                    ),
                                    new PopupMenuItem<String>(
                                        value: "/connection/add",
                                        child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                                new Icon(Icons.person_add),
                                                this._buildColumn(new Text("Add Connection")),
                                            ],
                                        ),
                                    ),
                                    new PopupMenuItem<String>(
                                        value: "/feed/create",
                                        child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                                new Icon(Icons.group_add),
                                                this._buildColumn(new Text("Create Feed")),
                                            ],
                                        ),
                                    ),
                                    new PopupMenuItem<String>(
                                        value: "/post/compose",
                                        child: new Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                                new Icon(Icons.edit),
                                                this._buildColumn(new Text("Compose Post")),
                                            ],
                                        ),
                                    ),
                                ];
                            },
                        ),
                    ],
                ),
                body: new TabBarView(
                    children: <Widget>[
                        new StreamComponent(),
                        new NotificationComponent(),
                    ],
                ),
                bottomNavigationBar: new Container(
                    color: Theme.of(context).accentColor,
                    child: new TabBar(
                        tabs: <Widget>[
                            new Tab(
                                icon: new Icon(Icons.view_list),
                            ),
                            new Tab(
                                icon: new Icon(Icons.notifications),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }

    Widget _buildColumn(Widget w) {
        return new Container(
            child: w,
            padding: new EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 10.0,
            ),
        );
    }

    void _navigateTo(BuildContext context, String path) {
        Navigator.of(context).pushNamed(path);
    }
}
