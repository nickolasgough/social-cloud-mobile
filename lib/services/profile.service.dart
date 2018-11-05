import 'dart:async';

import 'package:mobile/services/http.service.dart';


class ProfileService {
    static final ProfileService _profileService = new ProfileService._internal();

    static final HttpService _httpService = new HttpService();

    static String _username;
    static String _displayname;

    factory ProfileService() {
        return _profileService;
    }

    ProfileService._internal();

    Future<bool> createProfile(String username, String password, String displayname, DateTime datetime) async {
        Map<String, dynamic> body = {
            "username": username,
            "password": password,
            "displayname": displayname,
            "datetime": datetime.toUtc().toIso8601String(),
        };
        Map<String, dynamic> response = await _httpService.post("profile/create", body);

        bool success = response["success"];
        if (success) {
            _username = username;
            _displayname = displayname;
        } else {
            _username = null;
            _displayname = null;
        }
        return success;
    }

    Future<bool> loginProfile(String username, String password) async {
        Map<String, dynamic> body = {
            "username": username,
            "password": password,
        };
        Map<String, dynamic> response = await _httpService.post("profile/login", body);

        String displayname = response["displayname"];
        if (displayname != null) {
            _username = username;
            _displayname = displayname;
        } else {
            _username = null;
            _displayname = null;
        }
        return _displayname != null;
    }

    String getUsername() {
        return _username;
    }

    String getDisplayname() {
        return _displayname;
    }
}
