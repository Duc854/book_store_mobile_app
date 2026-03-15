import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class AdminCategoryService{

  static const baseUrl="http://localhost:7128/api/categories";

  static Future<List<Category>> getCategories() async{

    final res=await http.get(Uri.parse(baseUrl));

    List data=jsonDecode(res.body);

    return data.map((e)=>Category.fromJson(e)).toList();
  }

  static Future<void> createCategory(Category c) async{

    await http.post(
      Uri.parse(baseUrl),
      headers:{"Content-Type":"application/json"},
      body: jsonEncode(c.toJson())
    );
  }

  static Future<void> deleteCategory(int id) async{

    await http.delete(Uri.parse("$baseUrl/$id"));
  }
}