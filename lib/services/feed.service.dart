import 'dart:async';

import 'package:mobile/services/connection.service.dart';
import 'package:mobile/services/http.service.dart';


class FeedService {
    static final FeedService _feedService = new FeedService._internal();

    static final HttpService _httpService = new HttpService();

    factory FeedService() {
        return _feedService;
    }

    FeedService._internal();

    Future<bool> createFeed(String username, String feedname, List<Connection> members, DateTime datetime) async {
        Map<String, dynamic> body = {
            "username": username,
            "feedname": feedname,
            "members": _serializeFeed(members, datetime),
            "datetime": datetime.toUtc().toIso8601String(),
        };
        Map<String, dynamic> response = await _httpService.post("feed/create", body);

        bool success = response["success"];
        return success;
    }

    List<Map<String, dynamic>> _serializeFeed(List<Connection> members, DateTime datetime) {
        List<Map<String, dynamic>> data = new List<Map<String, dynamic>>();
        for (Connection member in members) {
            data.add({
                "connection": member.connection,
                "datetime": datetime.toUtc().toIso8601String(),
            });
        }
        return data;
    }
}
