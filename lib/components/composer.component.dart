import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/services/post.service.dart';

import 'package:mobile/services/profile.service.dart';


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
                        _buildColumn(
                            new Container(
                                child: new TextField(
                                    decoration: new InputDecoration(
                                        hintText: "Compose Post",
                                        contentPadding: new EdgeInsets.all(10.0),
                                        border: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 8,
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
                        onPressed: () => _createPost(context),
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

    void _createPost(context) {
        String username = this._profileService.getUsername();
        DateTime now = new DateTime.now();
        this._postService.CreatePost(username, _post, now).then(
            (success) => success
                ? this._handleSuccess(context)
                : this._handleFailure(context)
        );
    }

    void _handleSuccess(BuildContext context) {
        this._showSuccessSnackBar(context, "post successfully created");
        new Timer(const Duration(seconds: 1, milliseconds: 500), () => Navigator.of(context).pop());
    }

    void _handleFailure(BuildContext context) {
        this._showFailureSnackBar(context, "failed to create post");
    }

    void _showSuccessSnackBar(BuildContext context, String message) {
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

    void _showFailureSnackBar(BuildContext context, String message) {
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
}
