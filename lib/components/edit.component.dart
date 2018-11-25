import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/services/feed.service.dart';

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
    FeedService _feedService = new FeedService();

    String _displayname;
    String _password;
    File _imagefile;
    Future<List<Feed>> _feeds;
    String _defaultFeed;

    bool _initialized = false;

    void initialize() {
        if (!this._initialized) {
            this._initialized = true;
            this._displayname = this._profileService.getDisplayname();
            this._password = this._profileService.getPassword();
            this._defaultFeed = this._profileService.getDefaultFeed();
            this._feeds = this._feedService.listFeeds(this._profileService.getEmail());
        }
    }

    @override
    Widget build(BuildContext context) {
        this.initialize();

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
                                    labelText: "Display Name",
                                    hintText: "Display Name"
                                ),
                                onChanged: (value) => this._displayname = value,
                            )
                        ),
                        this._buildColumn(
                            new TextField(
                                controller: new TextEditingController(
                                    text: this._password,
                                ),
                                decoration: new InputDecoration(
                                    labelText: "Password",
                                    hintText: "Password"
                                ),
                                onChanged: (value) => this._password = value,
                            )
                        ),
                        this._buildDefaultFeed(),
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
            width: 200.0,
            height: 200.0,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    fit: BoxFit.contain,
                    image: imageProvider,
                ),
                border: new Border.all(
                    color: Theme.of(context).accentColor,
                ),
            ),
        );
    }

    Widget _buildDefault() {
        return new Container(
            child: new Icon(
                Icons.person,
                size: 200.0,
            ),
            decoration: new BoxDecoration(
                border: new Border.all(
                    color: Theme.of(context).accentColor,
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

    Widget _buildDefaultFeed() {
        return new FutureBuilder(
            future: this._feeds,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                    return new Container(
                        child: new Center(
                            child: this._buildFeeds(snapshot.data as List<Feed>),
                        ),
                        padding: new EdgeInsets.symmetric(
                            vertical: 10.0,
                        ),
                    );
                } else {
                    return new Center(
                        child: new CircularProgressIndicator(),
                    );
                }
            }
        );
    }

    Widget _buildFeeds(List<Feed> feeds) {
        List<DropdownMenuItem<String>> items = new List<DropdownMenuItem<String>>();
        for (Feed feed in feeds) {
            items.add(new DropdownMenuItem(
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

        return items.length > 0
            ? new DropdownButton(
                items: items,
                value: this._defaultFeed,
                onChanged: (value) => this.setState(() {
                    this._defaultFeed = value;
                }),
            ) : new Container();
    }

    void _updateProfile(BuildContext context) {
        showLoadingDialog(context);

        this._profileService.updateProfile(this._displayname, this._password, this._imagefile, this._defaultFeed).then(
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
