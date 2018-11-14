import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mobile/services/profile.service.dart';
import 'package:mobile/util/snackbar.util.dart';


class EditComponent extends StatefulWidget {
    EditComponent() : super();

    @override
    _EditComponentState createState() => new _EditComponentState();
}

class _EditComponentState extends State<EditComponent> {
    ProfileService _profileService = new ProfileService();

    File _image;

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Edit"),
            ),
            body: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        this._buildColumn(
                            new Container(
                                child: new IconButton(
                                    icon: new Icon(Icons.image),
                                    onPressed: this._pickImage,
                                ),
                                decoration: new BoxDecoration(
                                    border: new Border.all(color: Theme.of(context).accentColor),
                                    borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                                ),
                            ),
                        ),
                    ],
                ),
            ),
            floatingActionButton: new Builder(
                builder: (BuildContext context) {
                    return new FloatingActionButton(
                        child: new Icon(Icons.send),
                        onPressed: () => this._updateProfile(context),
                    );
                }
            ),
        );
    }

    Container _buildColumn(Widget w) {
        return new Container(
            child: w,
            padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        );
    }

    void _pickImage() async {
        File image = await ImagePicker.pickImage(source: ImageSource.camera);
        this.setState(() {
            this._image = image;
        });
    }

    void _updateProfile(BuildContext context) {
        print("updating");
    }
}
