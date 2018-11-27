import 'dart:async';
import 'dart:io';

import 'package:mobile/services/http.service.dart';


class CommentService {
    static final CommentService _commentService = new CommentService._internal();

    static final HttpService _httpService = new HttpService();

    factory CommentService() {
        return _commentService;
    }

    CommentService._internal();

    Future<bool> createComment(String postemail, DateTime posttime, String email, String comment, DateTime datetime) async {
        Map<String, dynamic> body = {
            "postemail": postemail,
            "posttime": posttime.toUtc().toIso8601String(),
            "email": email,
            "comment": comment,
            "datetime": datetime.toUtc().toIso8601String(),
        };
        Map<String, dynamic> response = await _httpService.post("comment/create", body);

        bool success = response["success"];
        return success;
    }

    Future<List<Comment>> listComments(String postemail, DateTime posttime, String email, String feedname) async {
        Map<String, dynamic> body = {
            "postemail": postemail,
            "posttime": posttime.toUtc().toIso8601String(),
            "email": email,
            "feedname": feedname,
            "cursor": 0,
            "limit": 25,
        };
        Map<String, dynamic> response = await _httpService.get("comment/list", body);

        List<Comment> comments = _deserializeComments(response["comments"]);
        return comments;
    }

    List<Comment> _deserializeComments(List<dynamic> data) {
        List<Comment> comments = new List<Comment>();
        if (data == null) {
            return comments;
        }

        Comment comment;
        Avatar avatar;
        DateTime datetime;
        for (Map<String, dynamic> d in data) {
            avatar = _deserializeAvatar(d["avatar"]);
            datetime = DateTime.parse(d["datetime"]).toLocal();
            comment = new Comment(d["email"], avatar, d["comment"], datetime);
            comments.add(comment);
        }
        return comments;
    }

    Avatar _deserializeAvatar(Map<String, dynamic> data) {
        return new Avatar(data["displayname"], data["imageurl"]);
    }
}

class Comment {
    String email;
    Avatar avatar;
    String comment;
    DateTime datetime;

    Comment(String email, Avatar avatar, String comment, DateTime datetime) {
        this.email = email;
        this.avatar = avatar;
        this.comment = comment;
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
