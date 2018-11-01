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
        print(route);
        Response response = await _client.post(route,
            headers: _headers,
            body: json.encode(body),
            encoding: Encoding.getByName("utf-8")
        );
        try {
            return json.decode(response.body);
        } catch (e) {
            return {
                "success": false,
                "error": e.toString()
            };
        }
    }

    String get _baseUrl {
        String scheme = "http";
        String ipAddress = "10.227.148.102";
        String port = "8080";
        return "$scheme://$ipAddress:$port";
    }
}
