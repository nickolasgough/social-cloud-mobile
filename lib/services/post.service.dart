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

    List<Post> _deserializePosts(List<Map<String, dynamic>> data) {
        List<Post> posts = new List<Post>();
        if (data == null) {
            return posts;
        }

        DateTime datetime;
        for (Map<String, dynamic> d in data) {
            datetime = DateTime.parse(d["datetime"]).toLocal();
            posts.add(new Post(d["username"], d["displayname"], d["post"], datetime));
        }
        return posts;
    }
}

class Post {
    String username;
    String displayname;
    String post;
    DateTime datetime;

    Post(String username, String displayname, String post, DateTime datetime) {
        this.username = username;
        this.displayname = displayname;
        this.post = post;
        this.datetime = datetime;
    }
}
