import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:Aksara_Literasi/common/constants.dart';
import 'package:http/http.dart' as http;

class MyApiService {
  final String _endpoint = Constants.myApiUrl;
  String? _jwtToken;

  void setToken(String? token) {
    _jwtToken = token;
  }

  Map<String, String> get _headers {
    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    if (_jwtToken != null) {
      headers["Authorization"] = "Bearer $_jwtToken";
    }
    return headers;
  }

  void _printRequestInfo(String method, String url,
      {Map<String, String>? headers}) {
    debugPrint('--- API Request ---');
    debugPrint('Method: $method');
    debugPrint('URL: $url');
    debugPrint('Headers: $headers');
    debugPrint('-------------------');
  }

  Future<http.Response> login(String email, String password) {
    final url = '$_endpoint/api/auth/login';
    final headers = _headers;
    final body = jsonEncode({'email': email, 'password': password});
    _printRequestInfo('POST', url, headers: headers);
    return http.post(Uri.parse(url), headers: headers, body: body);
  }

  Future<http.Response> getManagedNews() {
    final url = '$_endpoint/api/author/news';
    final headers = _headers;
    _printRequestInfo('GET', url, headers: headers);
    return http.get(Uri.parse(url), headers: headers);
  }

  Future<http.Response> createNews(Map<String, dynamic> data) {
    final url = '$_endpoint/api/author/news';
    final headers = _headers;
    final body = jsonEncode(data);
    _printRequestInfo('POST', url, headers: headers);
    return http.post(Uri.parse(url), headers: headers, body: body);
  }

  Future<http.Response> updateNews(String id, Map<String, dynamic> data) {
    final url = '$_endpoint/api/author/news/$id';
    final headers = _headers;
    final body = jsonEncode(data);
    _printRequestInfo('PUT', url, headers: headers);
    return http.put(Uri.parse(url), headers: headers, body: body);
  }

  Future<http.Response> deleteNews(String id) {
    final url = '$_endpoint/api/author/news/$id';
    final headers = _headers;
    _printRequestInfo('DELETE', url, headers: headers);
    return http.delete(Uri.parse(url), headers: headers);
  }
}
