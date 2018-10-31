import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

import 'package:mobile/services/http.service.dart';


class ProfileService {
    static final ProfileService profileService = new ProfileService._internal();

    static final HttpService httpService = new HttpService();

    static String _username;
    static String _displayname;

    factory ProfileService() {
        return profileService;
    }

    ProfileService._internal();

    Future<bool> CreateProfile(String username, String password, String displayname) async {
        Map<String, dynamic> body = {
            "username": username,
            "password": password,
            "displayname": displayname
        };
        Response response = await httpService.Post("profile/create", body);

        Map<String, dynamic> map = json.decode(response.body);
        bool success = map["success"];
        if (success) {
            _username = username;
            _displayname = displayname;
        } else {
            _username = null;
            _displayname = null;
        }
        return success;
    }
}
