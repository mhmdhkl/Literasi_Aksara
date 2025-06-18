import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static String apiBaseUrl = '${dotenv.env['API_BASE_URL']}';
  static String apiKey = '${dotenv.env['API_KEY']}';
  static String apiPrefix = '${dotenv.env['API_PREFIX']}';
}
