import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

import 'package:mobile/services/http.service.dart';


class PostService {
    static final PostService _postService = new PostService._internal();

    static final HttpService _httpService = new HttpService();

    factory PostService() {
        return _postService;
    }

    PostService._internal();

    Future<bool> CreatePost(String username, String post, DateTime datetime) async {
        Map<String, dynamic> body = {
            "username": username,
            "post": post,
            "datetime": datetime.toUtc().toIso8601String()
        };
        Map<String, dynamic> response = await _httpService.Post("post/create", body);

        bool success = response["success"];
        return success;
    }
}
