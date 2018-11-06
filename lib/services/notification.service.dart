import 'dart:async';

import 'package:mobile/services/http.service.dart';


class NotificationService {
    static final NotificationService _notificationService = new NotificationService._internal();

    static final HttpService _httpService = new HttpService();

    factory NotificationService() {
        return _notificationService;
    }

    NotificationService._internal();

    Future<List<Notice>> listNotices(String username) async {
        Map<String, dynamic> body = {
            "username": username,
            "cursor": 0,
            "limit": 10,
        };
        Map<String, dynamic> response = await _httpService.get("notification/list", body);

        return _parseNotices(response["notifications"]);
    }

    List<Notice> _parseNotices(List<Map<String, dynamic>> data) {
        List<Notice> notices = new List<Notice>();
        if (data == null) {
            return notices;
        }

        DateTime datetime;
        for (int n = 0; n < data.length; n += 1) {
            Map<String, dynamic> d = data[n];
            datetime = DateTime.parse(d["datetime"]).toLocal();
            notices.add(new Notice(d["username"], d["type"], d["sender"], d["dismissed"], datetime));
        }
        return notices;
    }
}

class Notice {
    String username;
    String type;
    String sender;
    bool dismissed;
    DateTime datetime;

    Notice(String username, String type, String sender, bool dismissed, DateTime datetime) {
        this.username = username;
        this.type = type;
        this.sender = sender;
        this.dismissed = dismissed;
        this.datetime = datetime;
    }
}
