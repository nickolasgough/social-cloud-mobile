import 'dart:async';

import 'package:mobile/services/http.service.dart';


class PostService {
    static final PostService _postService = new PostService._internal();

    static final HttpService _httpService = new HttpService();

    factory PostService() {
        return _postService;
    }

    PostService._internal();

    Future<bool> createPost(String username, String post, DateTime datetime) async {
        Map<String, dynamic> body = {
            "username": username,
            "post": post,
            "datetime": datetime.toUtc().toIso8601String(),
        };
        Map<String, dynamic> response = await _httpService.post("post/create", body);

        bool success = response["success"];
        return success;
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
            post = new Post(d["username"], avatar, d["post"], datetime);
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
    DateTime datetime;

    Post(String username, Avatar avatar, String post, DateTime datetime) {
        this.username = username;
        this.avatar = avatar;
        this.post = post;
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
