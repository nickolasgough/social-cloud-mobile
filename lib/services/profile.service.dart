import 'dart:async';
import 'dart:io';

import 'package:mobile/services/http.service.dart';


class ProfileService {
    static final ProfileService _profileService = new ProfileService._internal();

    static final HttpService _httpService = new HttpService();

    static String _username;
    static String _displayname;
    static String _imageurl;

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

        _handleResponse(username, response["displayname"], response["imageurl"]);
        return response["displayname"] != null || response["imageurl"] != null;
    }

    void _handleResponse(String username, String displayname, String imageurl) {
        if (displayname != null && displayname.isNotEmpty) {
            _username = username;
            _displayname = displayname;
            _imageurl = imageurl;
        }
    }

    Future<bool> updateProfile(String displayname, File imagefile) async {
        Map<String, dynamic> body = {
            "username": _username,
            "displayname": displayname,
            "imagefile": imagefile.readAsBytesSync(),
        };
        Map<String, dynamic> response = await _httpService.post("profile/update", body);

        _handleResponse(_username, response["displayname"], response["imageurl"]);
        return response["displayname"] != null || response["imageurl"] != null;
    }

    String getUsername() {
        return _username;
    }

    String getDisplayname() {
        return _displayname;
    }

    String getImageurl() {
        return _imageurl;
    }
}
