import 'package:flutter/material.dart';


void showSuccessSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Row(
            children: <Widget>[
                new Text("Success", style: new TextStyle(color: Colors.green)),
                new Text(": "),
                new Text(message),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
        )
    ));
}

void showFailureSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Row(
            children: <Widget>[
                new Text("Failure", style: new TextStyle(color: Colors.red)),
                new Text(": "),
                new Text(message),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
        )
    ));
}
