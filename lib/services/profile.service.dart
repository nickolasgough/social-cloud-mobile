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

    Future<bool> CreateProfile(String username, String password, String displayname) async {
        Map<String, dynamic> body = {
            "username": username,
            "password": password,
            "displayname": displayname
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

    String getUsername() {
        return _username;
    }

    String getDisplayname() {
        return _displayname;
    }
}
