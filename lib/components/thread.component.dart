import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/components/comment.component.dart';
import 'package:mobile/services/comment.service.dart';
import 'package:mobile/services/post.service.dart';
import 'package:mobile/services/profile.service.dart';
import 'package:mobile/util/datetime.util.dart';


class ThreadComponent extends StatefulWidget {
    final String feedname;
    final Post post;

    ThreadComponent({Key key, @required this.feedname, @required this.post}) : super();

    @override
    _ThreadComponentState createState() => new _ThreadComponentState(feedname: this.feedname, post: this.post);
}

class _ThreadComponentState extends State<ThreadComponent> {
    ProfileService _profileService = new ProfileService();
    CommentService _commentService = new CommentService();

    String feedname;
    Post post;
    Future<List<Comment>> _comments;

    _ThreadComponentState({Key key, @required this.feedname, @required this.post}): super();

    @override
    Widget build(BuildContext context) {
        this._comments = this._listComments();

        return new FutureBuilder(
            future: this._comments,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                    return new Scaffold(
                        appBar: new AppBar(
                            title: new Text("Comments"),
                        ),
                        body: this._buildComments(context, snapshot.data as List<Comment>),
                        floatingActionButton: new Builder(
                            builder: (BuildContext context) {
                                return new FloatingActionButton(
                                    child: new Icon(Icons.add_comment),
                                    onPressed: () => this._createComment(context, this.post),
                                );
                            },
                        ),
                    );
                } else {
                    return new Center(
                        child: new CircularProgressIndicator(),
                    );
                }
            },
        );
    }

    Widget _buildColumn(Widget w) {
        return new Container(
            child: w,
            padding: new EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 10.0,
            ),
        );
    }

    Future<List<Comment>> _listComments() async {
        String postemail = this.post.email;
        DateTime posttime = this.post.datetime;
        String email = this._profileService.getEmail();
        return this._commentService.listComments(postemail, posttime, email, this.feedname);
    }

    Widget _buildComments(BuildContext context, List<Comment> comments) {
        List<Widget> children = new List<Widget>();
        for (Comment comment in comments) {
            children.add(this._buildComment(context, comment));
        }

        return new ListView(
            children: children,
        );
    }

    Widget _buildComment(BuildContext context, Comment comment) {
        String datetime = longTime(comment.datetime);

        Card card = new Card(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    new ListTile(
                        leading: this._buildAvatar(comment.avatar.imageurl),
                        title: new Text(comment.avatar.displayname),
                        subtitle: new Text(datetime),
                    ),
                    this._buildBody(comment),
                ],
            ),
        );
        return this._buildColumn(card);
    }

    Widget _buildAvatar(String imageurl) {
        if (imageurl == null || imageurl.isEmpty) {
            return new Container(
                child: new Icon(
                    Icons.person,
                    size: 60.0,
                ),
                height: 60.0,
                width: 60.0,
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

        return new Container(
            height: 60.0,
            width: 60.0,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new NetworkImage(imageurl),
                    fit: BoxFit.contain,
                ),
                border: new Border.all(
                    color: Theme.of(context).accentColor,
                ),
                borderRadius: new BorderRadius.all(
                    new Radius.circular(50.0),
                ),
            ),
        );
    }

    Widget _buildBody(Comment comment) {
        List<Widget> children = <Widget>[
            this._buildColumn(new Container(
                child: new Text(comment.comment),
                padding: new EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                ),
            )),
        ];

        return new Column(
            children: children,
        );
    }

    void _createComment(BuildContext context, Post post) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) {
                    return new CommentComponent(post: this.post);
                }
            ),
        );
    }
}
