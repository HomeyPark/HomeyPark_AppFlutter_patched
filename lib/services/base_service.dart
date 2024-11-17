import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

class BaseService<T> {
  static final String baseUrl = dotenv.env['API_URL'] ?? '';
}
