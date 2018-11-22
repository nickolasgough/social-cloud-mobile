import 'dart:async';

import 'package:mobile/services/http.service.dart';


class NotificationService {
    static final NotificationService _notificationService = new NotificationService._internal();

    static final HttpService _httpService = new HttpService();

    factory NotificationService() {
        return _notificationService;
    }

    NotificationService._internal();

    Future<List<Notice>> listNotifications(String email) async {
        Map<String, dynamic> body = {
            "email": email,
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
            notice = new Notice(d["email"], d["type"], d["sender"], d["displayname"], d["dismissed"], datetime);
            notices.add(notice);
        }
        return notices;
    }

    Future<bool> dismissNotification(String email, String sender, DateTime datetime) async {
        Map<String, dynamic> body = {
            "email": email,
            "sender": sender,
            "datetime": datetime.toUtc().toIso8601String(),
        };
        Map<String, dynamic> response = await _httpService.get("notification/dismiss", body);

        return response["success"];
    }
}

class Notice {
    String email;
    String type;
    String sender;
    String displayname;
    bool dismissed;
    DateTime datetime;

    Notice(String email, String type, String sender, String displayname, bool dismissed, DateTime datetime) {
        this.email = email;
        this.type = type;
        this.sender = sender;
        this.displayname = displayname;
        this.dismissed = dismissed;
        this.datetime = datetime;
    }
}
