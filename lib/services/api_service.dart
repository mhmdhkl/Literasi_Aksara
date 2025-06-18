import 'package:http/http.dart' as http;
import 'package:tugasbesar_berita/common/constants.dart';

class ApiService {
  var client = http.Client();

  String endpoint = Constants.apiBaseUrl + Constants.apiPrefix;
  String apiKey = Constants.apiKey;

  Map<String, String> headers = {"Accept": "application/json"};

  Future<http.Response> getTopHeadlines() {
    return client.get(
      Uri.parse('$endpoint/top-headlines?apiKey=$apiKey'),
      headers: headers,
    );
  }

  Future<http.Response> getEverything(String keyword, int page) {
    return client.get(
      Uri.parse(
        '$endpoint/everything?q=$keyword&language=en&sortBy=publishedAt&page=$page&apiKey=$apiKey',
      ),
      headers: headers,
    );
  }
}
