import 'dart:async';

import 'package:mobile/services/http.service.dart';


class ConnectionService {
    static final ConnectionService _connectionService = new ConnectionService._internal();

    static final HttpService _httpService = new HttpService();

    factory ConnectionService() {
        return _connectionService;
    }

    ConnectionService._internal();

    Future<bool> requestConnection(String email, String connection, DateTime datetime) async {
        Map<String, dynamic> body = {
            "email": email,
            "connection": connection,
            "datetime": datetime.toUtc().toIso8601String()
        };
        Map<String, dynamic> response = await _httpService.post("connection/request", body);

        bool success = response["success"];
        return success;
    }

    Future<bool> acceptConnection(String email, String connection, DateTime datetime) async {
        Map<String, dynamic> body = {
            "email": email,
            "connection": connection,
            "datetime": datetime.toUtc().toIso8601String()
        };
        Map<String, dynamic> response = await _httpService.post("connection/accept", body);

        bool success = response["success"];
        return success;
    }

    Future<bool> declineConnection(String email, String connection, DateTime datetime) async {
        Map<String, dynamic> body = {
            "email": email,
            "connection": connection,
            "datetime": datetime.toUtc().toIso8601String()
        };
        Map<String, dynamic> response = await _httpService.post("connection/decline", body);

        bool success = response["success"];
        return success;
    }

    Future<List<Connection>> listConnections(String email) async {
        Map<String, dynamic> body = {
            "email": email,
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
            connection = new Connection(d["email"], d["connection"], d["displayname"], d["imageurl"], datetime);
            connections.add(connection);
        }
        return connections;
    }
}

class Connection {
    String email;
    String connection;
    String displayname;
    String imageurl;
    DateTime datetime;

    Connection(String email, String connection, String displayname, String imageurl, DateTime datetime) {
        this.email = email;
        this.connection = connection;
        this.displayname = displayname;
        this.imageurl = imageurl;
        this.datetime = datetime;
    }
}
