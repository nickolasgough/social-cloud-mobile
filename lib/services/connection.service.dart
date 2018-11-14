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

        List<Connection> connections = _parseConnections(response["connections"]);
        return connections;
    }

    List<Connection> _parseConnections(List<dynamic> data) {
        List<Connection> connections = new List<Connection>();
        if (data == null) {
            return connections;
        }

        Connection connection;
        DateTime datetime;
        for (Map<String, dynamic> d in data) {
            datetime = DateTime.parse(d["datetime"]).toLocal();
            connection = new Connection(d["username"], d["connection"], d["displayname"], datetime);
            connections.add(connection);
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
