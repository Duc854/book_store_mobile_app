import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class AdminCategoryService {

  static const baseUrl = "https://localhost:7128/api/Categories";

  static Future<List<Category>> getCategories() async {

    final res = await http.get(Uri.parse(baseUrl));

    List data = jsonDecode(res.body);

    return data.map((e) => Category.fromJson(e)).toList();
  }

  static Future<void> createCategory(Category c) async {

  final res = await http.post(
    Uri.parse(baseUrl),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(c.toJson()),
  );

  print(res.statusCode);
  print(res.body);

  if (res.statusCode != 200 && res.statusCode != 201) {
    throw Exception("Create category failed");
  }
}

  static Future<void> updateCategory(Category c) async {

  final res = await http.put(
    Uri.parse("$baseUrl/${c.id}"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(c.toJson()),
  );

  print(res.statusCode);
  print(res.body);

  if (res.statusCode != 200) {
    throw Exception("Update failed");
  }
}

  static Future<void> deleteCategory(int id) async {

    await http.delete(Uri.parse("$baseUrl/$id"));
  }
}