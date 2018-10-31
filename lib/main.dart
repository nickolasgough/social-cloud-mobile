import 'package:flutter/material.dart';
import 'package:mobile/components/home.component.dart';
import 'dart:async';

import 'package:mobile/components/registration.component.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Social Cloud',
      theme: new ThemeData(primarySwatch: Colors.blue),
      routes: <String, WidgetBuilder>{
        "/": (_) => new LoginPage(),
        "/home": (_) => new HomePage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage() : super();

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return new RegistrationComponent();
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new HomeComponent();
  }
}
