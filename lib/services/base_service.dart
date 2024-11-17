import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseService {
  static final String baseUrl = dotenv.env['API_URL'] ?? '';
}
