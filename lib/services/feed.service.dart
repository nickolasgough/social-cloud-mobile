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

    Future<bool> createFeed(String email, String feedname, List<Connection> members, DateTime datetime) async {
        Map<String, dynamic> body = {
            "email": email,
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

    Future<List<Feed>> listFeeds(String email) async {
        Map<String, dynamic> body = {
            "email": email,
            "cursor": 0,
            "limit": 10,
        };
        Map<String, dynamic> response = await _httpService.get("feed/list", body);

        List<Feed> feeds = _deserializeFeeds(response["feeds"]);
        return feeds;
    }

    List<Feed> _deserializeFeeds(List<dynamic> data) {
        List<Feed> feeds = new List<Feed>();
        if (data == null) {
            return feeds;
        }

        Feed feed;
        List<Member> members;
        DateTime datetime;
        for (Map<String, dynamic> d in data) {
            members = _deserializeMembers(d["members"]);
            datetime = DateTime.parse(d["datetime"]).toLocal();
            feed = new Feed(d["email"], d["feedname"], members, datetime);
            feeds.add(feed);
        }
        return feeds;
    }

    List<Member> _deserializeMembers(List<dynamic> data) {
        List<Member> members = new List<Member>();
        if (data == null) {
            return null;
        }

        Member member;
        DateTime datetime;
        for (Map<String, dynamic> d in data) {
            datetime = DateTime.parse(d["datetime"]).toLocal();
            member = new Member(d["connection"], datetime);
            members.add(member);
        }
        return members;
    }
}

class Feed {
    String email;
    String feedname;
    List<Member> members;
    DateTime datetime;

    Feed(String email, String feedname, List<Member> members, DateTime datetime) {
        this.email = email;
        this.feedname = feedname;
        this.members = members;
        this.datetime = datetime;
    }
}

class Member {
    String connection;
    DateTime datetime;

    Member(String connection, DateTime datetime) {
        this.connection = connection;
        this.datetime = datetime;
    }
}
