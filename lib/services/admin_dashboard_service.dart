import 'dart:convert';
import 'package:book_store_mobile_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class AdminDashboardService {
  static const String baseUrl = "https://localhost:7128/api/admin";

  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService().getToken();
    return {
      "Content-Type": "application/json",
      if (token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  static Future<Map<String, dynamic>> getStats() async {
    final headers = await _getHeaders();

    final res = await http.get(
      Uri.parse("$baseUrl/stats"),
      headers: headers,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else if (res.statusCode == 401) {
      throw Exception("Unauthorized: token missing or expired");
    } else {
      throw Exception("Load stats failed: ${res.statusCode}");
    }
  }
}