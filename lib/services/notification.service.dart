import 'dart:async';

import 'package:mobile/services/http.service.dart';


class NotificationService {
    static final NotificationService _notificationService = new NotificationService._internal();

    static final HttpService _httpService = new HttpService();

    factory NotificationService() {
        return _notificationService;
    }

    NotificationService._internal();

    Future<List<Notice>> ListNotices(String username) async {
        Map<String, dynamic> body = {
            "username": username,
            "cursor": 0,
            "limit": 10,
        };
        Map<String, dynamic> response = await _httpService.get("notification/list", body);

        return this._parseNotices(response["data"]);
    }

    List<Notice> _parseNotices(List<Map<String, dynamic>> data) {
        List<Notice> notices = [];
        data.forEach((Map<String, dynamic> notice) {
            Type type = notice["type"] == "connection" ? Type.Connection : Type.Like;
            DateTime datetime = DateTime.parse(notice["datetime"]);
            notices.add(new Notice(notice["username"], type, notice["sender"], notice["dismissed"], datetime));
        });
        return notices;
    }
}

class Notice {
    String username;
    Type type;
    String sender;
    bool dismissed;
    DateTime datetime;

    Notice(String username, Type type, String sender, bool dismissed, DateTime datetime) {
        this.username = username;
        this.type = type;
        this.sender = sender;
        this.dismissed = dismissed;
        this.datetime = datetime;
    }
}

enum Type {
    Connection,
    Like
}
