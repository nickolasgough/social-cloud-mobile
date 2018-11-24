import 'package:flutter/material.dart';

import 'package:mobile/components/connection.component.dart';
import 'package:mobile/components/edit.component.dart';
import 'package:mobile/components/feed.component.dart';
import 'package:mobile/components/login.component.dart';
import 'package:mobile/components/registration.component.dart';
import 'package:mobile/components/home.component.dart';
import 'package:mobile/components/composer.component.dart';
import 'package:mobile/components/startup.component.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return new MaterialApp(
            title: 'Social Cloud',
            theme: new ThemeData(
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: Colors.white,
                buttonTheme: new ButtonThemeData(
                    height: 40,
                    minWidth: 150.0,
                ),
                fontFamily: "Roboto",
            ),
            routes: <String, WidgetBuilder>{
                "/": (_) => new StartupComponent(),
                "/login": (_) => new LoginComponent(),
                "/register": (_) => new RegistrationComponent(),
                "/home": (_) => new HomeComponent(),
                "/profile/edit": (_) => new EditComponent(),
                "/connection/add": (_) => new ConnectionComponent(),
                "/feed/create": (_) => new FeedComponent(),
                "/post/compose": (_) => new ComposerComponent(),
            },
        );
    }
}
