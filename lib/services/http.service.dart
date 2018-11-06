import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';


class HttpService {
    static final HttpService _httpService = new HttpService._internal();

    static final Client _client = new Client();
    static final Map<String, dynamic> _headers = {
        "Content-Type": "application/json",
    };

    factory HttpService() {
        return _httpService;
    }

    HttpService._internal();

    Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
        final String route = "$_baseUrl/$path";
        Response response = await _client.post(route,
            headers: _headers,
            body: json.encode(body),
            encoding: Encoding.getByName("utf-8"),
        );
        try {
            return json.decode(response.body);
        } catch (e) {
            return {
                "success": false,
                "error": e.toString(),
            };
        }
    }

    Future<Map<String, dynamic>> get(String path, Map<String, dynamic> body) async {
        String route = "$_baseUrl/$path";
        if (body.length > 0) {
            route += "?";
        }
        List<String> parameters = [];
        body.forEach((String key, dynamic value) {
            parameters.add("$key=$value");
        });
        route += parameters.join("&");
        Response response = await _client.get(route,
            headers: _headers,
        );
        try {
            return json.decode(response.body);
        } catch (e) {
            return {
                "success": false,
                "error": e.toString(),
            };
        }
    }

    String get _baseUrl {
        String scheme = "http";
        String ipAddress = "10.227.137.240";
        String port = "8080";
        return "$scheme://$ipAddress:$port";
    }
}
