import 'package:flutter/material.dart';

import 'package:mobile/components/connection.component.dart';
import 'package:mobile/components/registration.component.dart';
import 'package:mobile/components/home.component.dart';
import 'package:mobile/components/composer.component.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return new MaterialApp(
            title: 'Social Cloud',
            theme: new ThemeData(primarySwatch: Colors.blue),
            routes: <String, WidgetBuilder>{
                "/": (_) => new RegistrationComponent(),
                "/home": (_) => new HomeComponent(),
                "/connection/add": (_) => new ConnectionComponent(),
                "/post/compose": (_) => new ComposerComponent(),
            },
        );
    }
}
