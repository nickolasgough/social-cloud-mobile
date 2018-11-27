import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile/services/comment.service.dart';
import 'package:mobile/services/post.service.dart';
import 'package:mobile/services/profile.service.dart';

import 'package:mobile/util/dialog.dart';
import 'package:mobile/util/snackbar.util.dart';


class CommentComponent extends StatefulWidget {
    final Post post;

    CommentComponent({Key key, @required this.post}) : super();

    @override
    _CommentComponentState createState() => new _CommentComponentState(post: this.post);
}

class _CommentComponentState extends State<CommentComponent> {
    ProfileService _profileService = new ProfileService();
    CommentService _commentService = new CommentService();

    Post post;
    String _comment;

    _CommentComponentState({Key key, @required this.post}): super();

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Comment"),
            ),
            body: new Center(
                child: new ListView(
                    children: <Widget>[
                        this._buildColumn(
                            new Container(
                                child: new TextField(
                                    decoration: new InputDecoration(
                                        labelText: "Comment",
                                        hintText: "Comment",
                                        contentPadding: new EdgeInsets.all(10.0),
                                        border: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    onChanged: (String value) => this._comment = value,
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
                        onPressed: () => this._createComment(context),
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

    void _createComment(BuildContext context) {
        showLoadingDialog(context);

        String postemail = this.post.email;
        DateTime posttime = this.post.datetime;
        String email = this._profileService.getEmail();
        DateTime now = new DateTime.now();
        this._commentService.createComment(postemail, posttime, email, this._comment, now).then(
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
        showSuccessSnackBar(context, "comment successfully created");
        new Timer(const Duration(
            seconds: 1,
        ), () => Navigator.of(context).pop());
    }

    void _handleFailure(BuildContext context) {
        showFailureSnackBar(context, "failed to create comment");
    }
}
