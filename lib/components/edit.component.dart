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
                child: new ListView(
                    children: <Widget>[
                        this._buildColumn(this._buildAvatar()),
                        new IconButton(
                            iconSize: 30.0,
                            icon: new Icon(Icons.camera_alt),
                            onPressed: this._pickImage,
                        ),
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
                vertical: 30.0,
                horizontal: 50.0,
            ),
        );
    }

    Widget _buildAvatar() {
        if (this._imagefile != null || this._profileService.hasProfileImage()) {
            return this._buildImage();
        } else {
            return this._buildDefault();
        }
    }

    Widget _buildImage() {
        var imageProvider = this._imagefile != null
            ? new FileImage(this._imagefile)
            : new NetworkImage(this._profileService.getImageurl());

        return new Container(
            width: 300.0,
            height: 300.0,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    fit: BoxFit.contain,
                    image: imageProvider,
                ),
                border: new Border.all(
                    color: Theme.of(context).accentColor,
                ),
                borderRadius: new BorderRadius.all(
                    new Radius.circular(150.0),
                ),
            ),
        );
    }

    Widget _buildDefault() {
        return new Container(
            child: new Icon(
                Icons.person,
                size: 300.0,
            ),
            decoration: new BoxDecoration(
                border: new Border.all(
                    color: Theme.of(context).accentColor,
                ),
                borderRadius: new BorderRadius.all(
                    new Radius.circular(50.0),
                ),
            ),
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
