import 'dart:async';
import 'dart:io';

import 'package:mobile/services/http.service.dart';
import 'package:mobile/util/file.dart';


class ProfileService {
    static final ProfileService _profileService = new ProfileService._internal();

    static final HttpService _httpService = new HttpService();

    static String _email;
    static String _password;
    static String _displayname;
    static String _imageurl;

    factory ProfileService() {
        return _profileService;
    }

    ProfileService._internal();

    Future<bool> createProfile(String email, String password, String displayname, DateTime datetime) async {
        Map<String, dynamic> body = {
            "email": email,
            "password": password,
            "displayname": displayname,
            "datetime": datetime.toUtc().toIso8601String(),
        };
        Map<String, dynamic> response = await _httpService.post("profile/create", body);

        bool success = response["success"];
        if (success) {
            _email = email;
            _password = password;
            _displayname = displayname;
        } else {
            _email = null;
            _password = null;
            _displayname = null;
        }
        return success;
    }

    Future<bool> loginProfile(String email, String password) async {
        Map<String, dynamic> body = {
            "email": email,
            "password": password,
        };
        Map<String, dynamic> response = await _httpService.post("profile/login", body);

        _handleResponse(email, password, response["displayname"], response["imageurl"]);
        return response["displayname"].isNotEmpty || response["imageurl"].isNotEmpty;
    }

    void _handleResponse(String email, String password, String displayname, String imageurl) {
        if (email != null && email.isNotEmpty) {
            _email = email;
        }
        if (password != null && password.isNotEmpty) {
            _password = password;
        }
        if (displayname != null && displayname.isNotEmpty) {
            _displayname = displayname;
        }
        if (imageurl != null && imageurl.isNotEmpty) {
            _imageurl = imageurl;
        }
    }

    Future<bool> updateProfile(String displayname, String password, File imagefile) async {
        Map<String, dynamic> body = {
            "email": _email,
            "password": password,
            "displayname": displayname,
            "imagefile": imagefile != null ? imagefile.readAsBytesSync() : null,
            "filename": imagefile != null ? parseFilename(imagefile) : null,
        };
        Map<String, dynamic> response = await _httpService.post("profile/update", body);

        _handleResponse(_email, password, response["displayname"], response["imageurl"]);
        return response["displayname"].isNotEmpty || response["imageurl"].isNotEmpty;
    }

    Future<bool> googleSignIn(String email, String displayname, String imageurl, DateTime datetime) async {
        Map<String, dynamic> body = {
            "email": email,
            "displayname": displayname,
            "imageurl": imageurl,
            "datetime": datetime.toUtc().toIso8601String(),
        };
        Map<String, dynamic> response = await _httpService.post("profile/google", body);

        _handleResponse(email, response["password"], response["displayname"], response["imageurl"]);
        return response["password"].isNotEmpty || response["displayname"].isNotEmpty || response["imageurl"].isNotEmpty;
    }

    String getEmail() {
        return _email;
    }

    String getPassword() {
        return _password;
    }

    String getDisplayname() {
        return _displayname;
    }

    bool hasProfileImage() {
        return _imageurl != null;
    }

    String getImageurl() {
        return _imageurl;
    }
}
