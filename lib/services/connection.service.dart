import 'dart:async';

import 'package:mobile/services/http.service.dart';


class ConnectionService {
    static final ConnectionService _connectionService = new ConnectionService._internal();

    static final HttpService _httpService = new HttpService();

    factory ConnectionService() {
        return _connectionService;
    }

    ConnectionService._internal();

    Future<bool> requestConnection(String username, String connection, DateTime datetime) async {
        Map<String, dynamic> body = {
            "username": username,
            "connection": connection,
            "datetime": datetime.toUtc().toIso8601String()
        };
        Map<String, dynamic> response = await _httpService.post("connection/request", body);

        bool success = response["success"];
        return success;
    }

    Future<bool> acceptConnection(String username, String connection, DateTime datetime) async {
        Map<String, dynamic> body = {
            "username": username,
            "connection": connection,
            "datetime": datetime.toUtc().toIso8601String()
        };
        Map<String, dynamic> response = await _httpService.post("connection/accept", body);

        bool success = response["success"];
        return success;
    }

    Future<bool> declineConnection(String username, String connection, DateTime datetime) async {
        Map<String, dynamic> body = {
            "username": username,
            "connection": connection,
            "datetime": datetime.toUtc().toIso8601String()
        };
        Map<String, dynamic> response = await _httpService.post("connection/decline", body);

        bool success = response["success"];
        return success;
    }
}
