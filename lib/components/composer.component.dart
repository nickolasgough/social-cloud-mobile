import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mobile/services/post.service.dart';
import 'package:mobile/services/profile.service.dart';
import 'package:mobile/util/snackbar.util.dart';


class ComposerComponent extends StatefulWidget {
    ComposerComponent() : super();

    @override
    _ComposerComponentState createState() => new _ComposerComponentState();
}

class _ComposerComponentState extends State<ComposerComponent> {
    String _post;

    ProfileService _profileService = new ProfileService();
    PostService _postService = new PostService();

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Composer"),
            ),
            body: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                    maxLines: 8,
                                    onChanged: (String value) => this._post = value,
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
                        onPressed: () => this._createPost(context),
                    );
                }
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

    void _createPost(context) {
        String username = this._profileService.getUsername();
        DateTime now = new DateTime.now();
        this._postService.createPost(username, this._post, now).then(
            (success) => success
                ? this._handleSuccess(context)
                : this._handleFailure(context)
        );
    }

    void _handleSuccess(BuildContext context) {
        showSuccessSnackBar(context, "post successfully created");
        new Timer(const Duration(seconds: 1, milliseconds: 500), () => Navigator.of(context).pop());
    }

    void _handleFailure(BuildContext context) {
        showFailureSnackBar(context, "failed to create post");
    }
}
