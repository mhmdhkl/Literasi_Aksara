import 'dart:convert';
import 'package:Aksara_Literasi/common/constants.dart';
import 'package:http/http.dart' as http;

class MyApiService {
  final String _endpoint = Constants.myApiUrl;

  // TODO: Replace with your actual JWT token retrieval logic
  final String _jwtToken =
      "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyMTQ0MmEyNy03NzRhLTQwMmItOTliYi00ZmY3OGE0MTllOTciLCJlbWFpbCI6Im5ld3NAaXRnLmFjLmlkIiwiaWF0IjoxNzUxMTAwNzU2LCJleHAiOjE3NTExODcxNTZ9.zjSadYiMrxD23B2_FbG8hd03lzL3ffvlaMOLg371Tys";

  Map<String, String> get _headers => {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $_jwtToken",
      };

  // GET /api/author/news
  Future<http.Response> getManagedNews() =>
      http.get(Uri.parse('$_endpoint/api/author/news'), headers: _headers);

  // POST /api/author/news
  Future<http.Response> createNews(Map<String, dynamic> data) =>
      http.post(Uri.parse('$_endpoint/api/author/news'),
          headers: _headers, body: jsonEncode(data));

  // PUT /api/author/news/{id}
  Future<http.Response> updateNews(String id, Map<String, dynamic> data) =>
      http.put(Uri.parse('$_endpoint/api/author/news/$id'),
          headers: _headers, body: jsonEncode(data));

  // DELETE /api/author/news/{id}
  Future<http.Response> deleteNews(String id) => http
      .delete(Uri.parse('$_endpoint/api/author/news/$id'), headers: _headers);
}
