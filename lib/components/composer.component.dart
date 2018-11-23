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
    String _linkurl;

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
                                        labelText: "Post",
                                        hintText: "Post",
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
                        this._buildColumn(
                            new Container(
                                child: new TextField(
                                    decoration: new InputDecoration(
                                        labelText: "Link",
                                        hintText: "Link",
                                        contentPadding: new EdgeInsets.all(10.0),
                                        border: InputBorder.none,
                                    ),
                                    onChanged: (String value) => this._linkurl = value,
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
                top: 10.0,
            ),
        );
    }

    Widget _buildPhoto() {
        if (this._imagefile == null) {
            return new Container(
                child: new Icon(
                    Icons.photo,
                    size: 250.0,
                ),
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

        return new Container(
            width: 250.0,
            height: 250.0,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    fit: BoxFit.contain,
                    image: new FileImage(this._imagefile),
                ),
                border: new Border.all(
                    color: Theme.of(context).accentColor,
                ),
                borderRadius: new BorderRadius.all(
                    new Radius.circular(10.0),
                ),
            ),
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

        String email = this._profileService.getEmail();
        DateTime now = new DateTime.now();
        this._postService.createPost(email, this._post, this._imagefile, this._linkurl, now).then(
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
