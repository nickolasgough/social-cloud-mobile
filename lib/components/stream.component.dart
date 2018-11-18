import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/services/feed.service.dart';
import 'package:mobile/services/post.service.dart';
import 'package:mobile/services/profile.service.dart';
import 'package:mobile/util/snackbar.util.dart';
import 'package:mobile/util/datetime.util.dart';


class StreamComponent extends StatefulWidget {
    StreamComponent() : super();

    @override
    _StreamComponentState createState() => new _StreamComponentState();
}

class _StreamComponentState extends State<StreamComponent> {
    ProfileService _profileService = new ProfileService();
    FeedService _feedService = new FeedService();
    PostService _postService = new PostService();

    Future<List<Feed>> _feeds;
    String _feedname;

    Future<List<Post>> _posts;

    @override
    Widget build(BuildContext context) {
        this._feeds = this._listFeeds();
        this._feedname = this._feedService.feedname;

        return new FutureBuilder(
            future: this._feeds,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                    return this._buildFeeds(context, snapshot.data as List<Feed>);
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

    Future<List<Feed>> _listFeeds() async {
        String username = this._profileService.getUsername();
        return this._feedService.listFeeds(username);
    }

    Widget _buildFeeds(BuildContext context, List<Feed> feeds) {
        List<PopupMenuItem<String>> items = new List<PopupMenuItem<String>>();
        for (Feed feed in feeds) {
            items.add(new PopupMenuItem<String>(
                value: feed.feedname,
                child: new Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                        new Icon(Icons.group),
                        this._buildColumn(new Text(feed.feedname)),
                    ],
                ),
            ));
        }

        Widget dropdownButton = items.length > 0
            ? new Container(
                child: new PopupMenuButton<String>(
                    icon: new Icon(
                        Icons.group,
                        color: Colors.white,
                    ),
                    onSelected: (feedname) => this.setState(() {
                        this._feedService.feedname = feedname;
                    }),
                    itemBuilder: (BuildContext context) {
                        return items;
                    },
                ),
                decoration: new BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: new BorderRadius.all(
                        new Radius.circular(50.0),
                    ),
                ),
            ) : null;
        return new Scaffold(
            body: this._buildStream(this._feedname),
            floatingActionButton: dropdownButton
        );
    }

    Widget _buildStream(String feedname) {
        String username = this._profileService.getUsername();
        this._posts = this._postService.listPosts(username, feedname);

        return new FutureBuilder(
            future: this._posts,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                    return this._buildPosts(context, snapshot.data as List<Post>);
                } else {
                    return new Center(
                        child: new CircularProgressIndicator(),
                    );
                }
            }
        );
    }

    Widget _buildPosts(BuildContext context, List<Post> posts) {
        List<Widget> children = new List<Widget>();
        for (Post post in posts) {
            children.add(this._buildPost(context, post));
        }

        return new ListView(
            children: children,
            padding: new EdgeInsets.only(
                bottom: 70.0,
            ),
        );
    }

    Widget _buildPost(BuildContext context, Post post) {
        String datetime = longTime(post.datetime);

        Card card = new Card(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    new ListTile(
                        leading: this._buildAvatar(post.avatar.imageurl),
                        title: new Text(post.avatar.displayname),
                        subtitle: new Text(datetime),
                    ),
                    this._buildBody(post),
                    this._buildButtons(context, post),
                ],
            ),
        );
        return this._buildColumn(card);
    }

    Widget _buildAvatar(String imageurl) {
        if (imageurl == null || imageurl.isEmpty) {
            return new Container(
                child: new Icon(Icons.person,
                    size: 50.0,
                ),
                height: 50.0,
                width: 50.0,
                decoration: new BoxDecoration(
                    border: new Border.all(color: Theme.of(context).accentColor),
                    borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                ),
            );
        }

        return new Container(
            height: 50.0,
            width: 50.0,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new NetworkImage(imageurl),
                    fit: BoxFit.cover,
                ),
                border: new Border.all(color: Theme.of(context).accentColor),
                borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
            ),
        );
    }

    Widget _buildBody(Post post) {
        List<Widget> children = <Widget>[
            this._buildColumn(new Text(post.post)),
        ];
        Widget photo = this._buildPhoto(post.imageurl);
        if (photo != null) {
            children.add(this._buildColumn(photo));
        }

        return new Column(
            children: children,
        );
    }

    Widget _buildPhoto(String imageurl) {
        if (imageurl == null || imageurl.isEmpty) {
            return null;
        }

        return new Container(
            height: 150.0,
            width: 150.0,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new NetworkImage(imageurl),
                    fit: BoxFit.cover,
                ),
                border: new Border.all(color: Theme.of(context).accentColor),
                borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            ),
        );
    }

    Widget _buildButtons(BuildContext context, Post post) {
        ButtonTheme buttonBar = new ButtonTheme.bar(
            child: new ButtonBar(
                children: <Widget>[
                    this._buildButton(context, post, "dislike"),
                    this._buildButton(context, post, "like"),
                ],
            ),
        );

        return new Container(
            child: buttonBar,
            padding: new EdgeInsets.symmetric(
                horizontal: 10.0,
            ),
        );
    }

    Widget _buildButton(BuildContext context, Post post, String reaction) {
        bool reacted;
        IconData iconData;
        int reactions;
        if (reaction == "like") {
            reacted = post.liked;
            iconData = Icons.thumb_up;
            reactions = post.likes;
        } else {
            reacted = post.disliked;
            iconData = Icons.thumb_down;
            reactions = post.dislikes;
        }
        return new Row(
            children: <Widget>[
                new IconButton(
                    onPressed: post.liked || post.disliked
                        ? null
                        : () => reaction == "like"
                            ? this._likePost(context, post)
                            : this._dislikePost(context, post),
                    icon: reacted
                        ? new Icon(iconData, color: Theme.of(context).accentColor)
                        : new Icon(iconData),
                ),
                new Text(reactions.toString()),
            ],
        );
    }

    void _likePost(BuildContext context, Post post) {
        String username = this._profileService.getUsername();
        DateTime datetime = new DateTime.now();
        this._postService.likePost(username, post, datetime).then(
            (success) {
                if (success) {
                    this.setState(() {
                        post.likes += 1;
                    });
                    this._handleSuccess(context, "liked");
                } else {
                    this._handleFailure(context, "like");
                }
            }
        );
    }

    void _dislikePost(BuildContext context, Post post) {
        String username = this._profileService.getUsername();
        DateTime datetime = new DateTime.now();
        this._postService.dislikePost(username, post, datetime).then(
            (success) {
                if (success) {
                    this.setState(() {
                        post.dislikes += 1;
                    });
                    this._handleSuccess(context, "disliked");
                } else {
                    this._handleFailure(context, "dislike");
                }
            }
        );
    }

    void _handleSuccess(BuildContext context, String reaction) {
        showSuccessSnackBar(context, "Successfully ${reaction} the post");
    }

    void _handleFailure(BuildContext context, String reaction) {
        showFailureSnackBar(context, "Failed to ${reaction} the post");
    }
}
