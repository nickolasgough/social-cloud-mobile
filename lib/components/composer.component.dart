import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mobile/services/post.service.dart';
import 'package:mobile/services/profile.service.dart';
import 'package:mobile/util/dialog.dart';
import 'package:mobile/util/snackbar.util.dart';


class ComposerComponent extends StatefulWidget {
    ComposerComponent() : super();

    @override
    _ComposerComponentState createState() => new _ComposerComponentState();
}

class _ComposerComponentState extends State<ComposerComponent> {
    ProfileService _profileService = new ProfileService();
    PostService _postService = new PostService();

    String _post;
    File _imagefile;

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Composer"),
            ),
            body: new Center(
                child: new ListView(
                    children: <Widget>[
                        this._buildColumn(
                            new Container(
                                child: new TextField(
                                    decoration: new InputDecoration(
                                        hintText: "Compose Post",
                                        contentPadding: new EdgeInsets.all(10.0),
                                        border: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    onChanged: (String value) => this._post = value,
                                ),
                                decoration: new BoxDecoration(
                                    border: new Border.all(
                                        color: Theme.of(context).accentColor,
                                    ),
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(10.0),
                                    ),
                                ),
                            ),
                        ),
                        this._buildColumn(this._buildPhoto()),
                        this._buildColumn(
                            new IconButton(
                                iconSize: 30.0,
                                icon: new Icon(Icons.camera_alt),
                                onPressed: this._pickImage,
                            ),
                        ),
                    ],
                ),
            ),
            floatingActionButton: new Builder(
                builder: (BuildContext context) {
                    return new FloatingActionButton(
                        child: new Icon(Icons.send),
                        onPressed: () => this._createPost(context),
                    );
                }
            ),
        );
    }

    Widget _buildColumn(Widget w) {
        return new Container(
            child: w,
            padding: new EdgeInsets.only(
                left: 50.0,
                right: 50.0,
                top: 30.0,
            ),
        );
    }

    Widget _buildPhoto() {
        Widget child = this._imagefile != null
            ? this._buildImage()
            : this._buildDefault();

        return new Container(
            child: child,
            decoration: new BoxDecoration(
                border: new Border.all(
                    color: Theme.of(context).accentColor,
                ),
                borderRadius: new BorderRadius.all(
                    new Radius.circular(10.0),
                ),
            ),
        );
    }

    Widget _buildImage() {
        return Image.file(
            this._imagefile,
            height: 300.0,
            width: 300.0,
        );
    }

    Widget _buildDefault() {
        return new Icon(
            Icons.photo,
            size: 300.0,
        );
    }

    void _pickImage() async {
        File image = await ImagePicker.pickImage(
            source: ImageSource.gallery,
        );
        this.setState(() {
            this._imagefile = image;
        });
    }

    void _createPost(BuildContext context) {
        showLoadingDialog(context);

        String username = this._profileService.getUsername();
        DateTime now = new DateTime.now();
        this._postService.createPost(username, this._post, this._imagefile, now).then(
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
        showSuccessSnackBar(context, "post successfully created");
        new Timer(const Duration(
            seconds: 1,
        ), () => Navigator.of(context).pop());
    }

    void _handleFailure(BuildContext context) {
        showFailureSnackBar(context, "failed to create post");
    }
}
