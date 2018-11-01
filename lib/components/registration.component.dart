import 'package:flutter/material.dart';

import 'package:mobile/services/profile.service.dart';


class RegistrationComponent extends StatefulWidget {
    RegistrationComponent() : super();

    @override
    _RegistrationComponentState createState() => new _RegistrationComponentState();
}

class _RegistrationComponentState extends State<RegistrationComponent> {
    String username;
    String password;
    String displayname;

    ProfileService profileService = new ProfileService();

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Registration"),
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
                        _buildColumn(
                            new TextField(
                                decoration: new InputDecoration(
                                    hintText: "Password"
                                ),
                                onChanged: (value) => this.password = value,
                            )
                        ),
                        _buildColumn(
                            new TextField(
                                decoration: new InputDecoration(
                                    hintText: "Display Name"
                                ),
                                onChanged: (value) => this.displayname = value,
                            )
                        ),
                        _buildColumn(
                            new RaisedButton(
                                child: new Text(
                                    "Submit",
                                    style: new TextStyle(
                                        color: Colors.white
                                    )
                                ),
                                color: Theme.of(context).accentColor,
                                onPressed: () => _handleSubmit(context),
                            ),
                        )
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

    void _handleSubmit(BuildContext context) {
        profileService.CreateProfile(username, password, displayname).then(
            (success) => success
                ? Navigator.of(context).pushReplacementNamed("/home")
                : Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Error: failed to register profile")))
        );
    }
}
