import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mobile/services/profile.service.dart';
import 'package:mobile/util/dialog.dart';
import 'package:mobile/util/snackbar.util.dart';


class EditComponent extends StatefulWidget {
    EditComponent() : super();

    @override
    _EditComponentState createState() => new _EditComponentState();
}

class _EditComponentState extends State<EditComponent> {
    ProfileService _profileService = new ProfileService();

    String _displayname;
    File _imagefile;

    @override
    Widget build(BuildContext context) {
        this._displayname = this._profileService.getDisplayname();

        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Edit"),
            ),
            body: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                        this._buildColumn(
                            new TextField(
                                controller: new TextEditingController(
                                    text: this._displayname,
                                ),
                                decoration: new InputDecoration(
                                    hintText: "Display Name"
                                ),
                                onChanged: (value) => this._displayname = value,
                            )
                        ),
                        this._buildColumn(this._buildAvatar()),
                        new IconButton(
                            icon: new Icon(Icons.camera_alt),
                            onPressed: this._pickImage,
                        ),
                    ],
                ),
            ),
            floatingActionButton: new Builder(
                builder: (BuildContext context) {
                    return new FloatingActionButton(
                        child: new Icon(Icons.check),
                        onPressed: () => this._updateProfile(context),
                    );
                },
            ),
        );
    }

    Widget _buildColumn(Widget w) {
        return new Container(
            child: w,
            padding: new EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
            ),
        );
    }

    Widget _buildAvatar() {
        Widget child = this._imagefile != null
            ? this._buildImage()
            : this._buildDefault();

        return new Container(
            child: child,
            decoration: new BoxDecoration(
                border: new Border.all(color: Theme.of(context).accentColor),
                borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            ),
        );
    }

    Widget _buildImage() {
        return Image.file(
            this._imagefile,
            height: 150.0,
            width: 150.0,
        );
    }

    Widget _buildDefault() {
        if (this._profileService.hasProfileImage()) {
            return new Image.network(
                this._profileService.getImageurl(),
                height: 150.0,
                width: 150.0,
            );
        }
        return new Icon(Icons.person,
            size: 150.0,
        );
    }

    void _pickImage() async {
        File image = await ImagePicker.pickImage(source: ImageSource.gallery);
        this.setState(() {
            this._imagefile = image;
        });
    }

    void _updateProfile(BuildContext context) {
        showLoadingDialog(context);

        this._profileService.updateProfile(this._displayname, this._imagefile).then(
            (success) {
                Navigator.of(context).pop();
                if (success) {
                    this._handleSuccess(context);
                } else {
                    this._handleFailure(context);
                }
            }
        );
    }

    void _handleSuccess(BuildContext context) {
        showSuccessSnackBar(context, "profile update successful");
        new Timer(const Duration(
            seconds: 1,
        ), () => Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false));
    }

    void _handleFailure(BuildContext context) {
        showFailureSnackBar(context, "failed to update profile");
    }
}
