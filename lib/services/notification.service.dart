import 'dart:async';

import 'package:mobile/services/http.service.dart';


class NotificationService {
    static final NotificationService _notificationService = new NotificationService._internal();

    static final HttpService _httpService = new HttpService();

    factory NotificationService() {
        return _notificationService;
    }

    NotificationService._internal();

    Future<List<Notice>> listNotifications(String username) async {
        Map<String, dynamic> body = {
            "username": username,
            "cursor": 0,
            "limit": 10,
        };
        Map<String, dynamic> response = await _httpService.get("notification/list", body);
        return _deserializeNotifications(response["notifications"]);
    }

    List<Notice> _deserializeNotifications(List<dynamic> data) {
        List<Notice> notices = new List<Notice>();
        if (data == null) {
            return notices;
        }

        Notice notice;
        DateTime datetime;
        for (Map<String, dynamic> d in data) {
            datetime = DateTime.parse(d["datetime"]).toLocal();
            notice = new Notice(d["username"], d["type"], d["sender"], d["displayname"], d["dismissed"], datetime);
            notices.add(notice);
        }
        return notices;
    }

    Future<bool> dismissNotification(String username, String sender, DateTime datetime) async {
        Map<String, dynamic> body = {
            "username": username,
            "sender": sender,
            "datetime": datetime.toUtc().toIso8601String(),
        };
        Map<String, dynamic> response = await _httpService.get("notification/dismiss", body);

        return response["success"];
    }
}

class Notice {
    String username;
    String type;
    String sender;
    String displayname;
    bool dismissed;
    DateTime datetime;

    Notice(String username, String type, String sender, String displayname, bool dismissed, DateTime datetime) {
        this.username = username;
        this.type = type;
        this.sender = sender;
        this.displayname = displayname;
        this.dismissed = dismissed;
        this.datetime = datetime;
    }
}
