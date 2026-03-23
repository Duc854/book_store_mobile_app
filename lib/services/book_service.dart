import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_endpoints.dart';
import '../models/book.dart';

class BookService {
  Future<List<Book>> getBestSellers() async {
    try {
      final response = await http.get(Uri.parse(ApiEndpoints.bestSellers));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('DEBUG: Lỗi getBestSellers: $e');
      return [];
    }
  }

  Future<List<Book>> getAllBooks({String? search, int? categoryId}) async {
    try {
      String url = ApiEndpoints.books;
      if (search != null || categoryId != null) {
        url += '?';
        if (search != null) url += 'search=$search&';
        if (categoryId != null) url += 'categoryId=$categoryId';
      }
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('DEBUG: Lỗi getAllBooks: $e');
      return [];
    }
  }

  Future<Book?> getBookById(int id) async {
    try {
      final response = await http.get(Uri.parse('${ApiEndpoints.books}/$id'));
      if (response.statusCode == 200) {
        return Book.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('DEBUG: Lỗi getBookById: $e');
      return null;
    }
  }
}
