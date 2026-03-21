import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminHomeService {
  static const String baseUrl = "https://localhost:7128/api/admin";

  static Future<Map<String, dynamic>> getStats() async {
    final res = await http.get(Uri.parse("$baseUrl/stats"));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Load stats failed");
    }
  }
}