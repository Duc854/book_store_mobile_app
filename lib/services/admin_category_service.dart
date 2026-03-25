import 'dart:convert';
import 'package:book_store_mobile_app/services/auth_service.dart';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class AdminCategoryService {

  static const baseUrl = "https://localhost:7128/api/Categories";
 static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService().getToken();
    return {
      "Content-Type": "application/json",
      if (token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }
  static Future<List<Category>> getCategories() async {

    final res = await http.get(Uri.parse(baseUrl));

    List data = jsonDecode(res.body);

    return data.map((e) => Category.fromJson(e)).toList();
  }

  static Future<void> createCategory(Category c) async {
    final headers = await _getHeaders();
  final res = await http.post(
    Uri.parse(baseUrl),
    headers: headers,
    body: jsonEncode(c.toCreateJson()),
  );

  print("STATUS: ${res.statusCode}");
  print("BODY: ${res.body}");

  if (res.statusCode != 200 && res.statusCode != 201) {
    throw Exception("Create category failed: ${res.body}");
  }
}

  static Future<void> updateCategory(Category c) async {
final headers = await _getHeaders();
  final res = await http.put(
    Uri.parse("$baseUrl/${c.id}"),
    headers: headers,
    body: jsonEncode(c.toUpdateJson()),
  );

  print(res.statusCode);
  print(res.body);

  if (res.statusCode != 200) {
    throw Exception("Update failed");
  }
}

  static Future<void> deleteCategory(int id) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse("$baseUrl/$id"),  headers: headers, );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Delete book failed: ${response.body}");
    }
  }
}