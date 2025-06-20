import 'dart:convert';
import 'package:tugasbesar_berita/common/constants.dart';
import 'package:http/http.dart' as http;

class MyApiService {
  final String _endpoint = Constants.myApiUrl;
  final Map<String, String> _headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  Future<http.Response> getManagedNews() =>
      http.get(Uri.parse('$_endpoint/berita/berita'), headers: _headers);

  Future<http.Response> createNews(Map<String, dynamic> data) =>
      http.post(Uri.parse('$_endpoint/berita/berita'),
          headers: _headers, body: jsonEncode(data));

  Future<http.Response> updateNews(String id, Map<String, dynamic> data) =>
      http.put(Uri.parse('$_endpoint/berita/berita/$id'),
          headers: _headers, body: jsonEncode(data));

  Future<http.Response> deleteNews(String id) =>
      http.delete(Uri.parse('$_endpoint/berita/berita/$id'), headers: _headers);
}
