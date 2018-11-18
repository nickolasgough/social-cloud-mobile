import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void showLoadingDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
            return new Center(
                child: new Container(
                    height: 150.0,
                    width: 150.0,
                    child: new Center(
                        child: new CircularProgressIndicator(),
                    ),
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(50.0),
                        ),
                    ),
                ),
            );
        },
    );
}
