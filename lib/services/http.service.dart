import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';


class HttpService {
    static final HttpService httpService = new HttpService._internal();

    static final Client _client = new Client();
    static final _url = "http://10.227.142.35:8080";
    static final Map<String, dynamic> headers = {
        "Content-Type": "application/json",
    };

    factory HttpService() {
        return httpService;
    }

    HttpService._internal();

    Future<Response> Post(String path, Map<String, dynamic> body) {
        final String route = "$_url/$path";
        print(route);
        return _client.post(route,
            headers: headers,
            body: json.encode(body),
            encoding: Encoding.getByName("utf-8")
        );
    }
}
