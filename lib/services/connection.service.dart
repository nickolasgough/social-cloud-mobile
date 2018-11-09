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

    Future<List<Connection>> listConnections(String username) async {
        Map<String, dynamic> body = {
            "username": username,
            "cursor": 0,
            "limit": 10,
        };
        Map<String, dynamic> response = await _httpService.get("connection/list", body);

        return _parseConnections(response["connections"]);
    }

    List<Connection> _parseConnections(List<Map<String, dynamic>> data) {
        List<Connection> connections = new List<Connection>();
        if (data == null) {
            return connections;
        }

        DateTime datetime;
        for (int n = 0; n < data.length; n += 1) {
            Map<String, dynamic> d = data[n];
            datetime = DateTime.parse(d["datetime"]).toLocal();
            connections.add(new Connection(d["username"], d["connection"], d["displayname"], datetime));
        }
        return connections;
    }
}

class Connection {
    String username;
    String connection;
    String displayname;
    DateTime datetime;

    Connection(String username, String connection, String displayname, DateTime datetime) {
        this.username = username;
        this.connection = connection;
        this.displayname = displayname;
        this.datetime = datetime;
    }
}
