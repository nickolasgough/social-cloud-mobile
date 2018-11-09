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
}
