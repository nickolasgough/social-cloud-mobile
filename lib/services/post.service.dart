import 'dart:async';
import 'dart:io';

import 'package:mobile/services/http.service.dart';
import 'package:mobile/util/file.dart';


class PostService {
    static final PostService _postService = new PostService._internal();

    static final HttpService _httpService = new HttpService();

    factory PostService() {
        return _postService;
    }

    PostService._internal();

    Future<bool> createPost(String username, String post, File imagefile, DateTime datetime) async {
        Map<String, dynamic> body = {
            "username": username,
            "post": post,
            "filename": imagefile != null ? parseFilename(imagefile) : null,
            "imagefile": imagefile != null ? imagefile.readAsBytesSync() : null,
            "datetime": datetime.toUtc().toIso8601String(),
        };
        Map<String, dynamic> response = await _httpService.post("post/create", body);

        bool success = response["success"];
        return success;
    }

    Future<bool> likePost(String username, Post post, DateTime datetime) async {
        Map<String, dynamic> body = {
            "username": username,
            "post": _serializePost(post),
            "reaction": "liked",
            "reacttime": datetime.toUtc().toIso8601String(),
        };
        Map<String, dynamic> response = await _httpService.post("post/react", body);

        bool success = response["success"];
        return success;
    }

    Future<bool> dislikePost(String username, Post post, DateTime datetime) async {
        Map<String, dynamic> body = {
            "username": username,
            "post": _serializePost(post),
            "reaction": "disliked",
            "reacttime": datetime.toUtc().toIso8601String(),
        };
        Map<String, dynamic> response = await _httpService.post("post/react", body);

        bool success = response["success"];
        return success;
    }

    Map<String, dynamic> _serializePost(Post post) {
        return {
            "username": post.username,
            "avatar": _serializeAvatar(post.avatar),
            "post": post.post,
            "imageurl": post.imageurl,
            "datetime": post.datetime.toUtc().toIso8601String(),
        };
    }

    Map<String, dynamic> _serializeAvatar(Avatar avatar) {
        return {
            "displayname": avatar.displayname,
            "imageurl": avatar.imageurl,
        };
    }

    Future<List<Post>> listPosts(String username, String feedname) async {
        Map<String, dynamic> body = {
            "username": username,
            "feedname": feedname,
            "cursor": 0,
            "limit": 25,
        };
        Map<String, dynamic> response = await _httpService.get("post/list", body);

        List<Post> posts = _deserializePosts(response["posts"]);
        return posts;
    }

    List<Post> _deserializePosts(List<dynamic> data) {
        List<Post> posts = new List<Post>();
        if (data == null) {
            return posts;
        }

        Post post;
        Avatar avatar;
        DateTime datetime;
        for (Map<String, dynamic> d in data) {
            avatar = _deserializeAvatar(d["avatar"]);
            datetime = DateTime.parse(d["datetime"]).toLocal();
            post = new Post(d["username"], avatar, d["post"], d["imageurl"], d["likes"], d["dislikes"], d["liked"], d["disliked"], datetime);
            posts.add(post);
        }
        return posts;
    }

    Avatar _deserializeAvatar(Map<String, dynamic> data) {
        return new Avatar(data["displayname"], data["imageurl"]);
    }
}

class Post {
    String username;
    Avatar avatar;
    String post;
    String imageurl;
    int likes;
    int dislikes;
    bool liked;
    bool disliked;
    DateTime datetime;

    Post(String username, Avatar avatar, String post, String imageurl, int likes, int dislikes, bool liked, bool disliked, DateTime datetime) {
        this.username = username;
        this.avatar = avatar;
        this.post = post;
        this.imageurl = imageurl;
        this.likes = likes;
        this.dislikes = dislikes;
        this.liked = liked;
        this.disliked = disliked;
        this.datetime = datetime;
    }
}

class Avatar {
    String displayname;
    String imageurl;

    Avatar(String displayname, String imageurl) {
        this.displayname = displayname;
        this.imageurl = imageurl;
    }
}
