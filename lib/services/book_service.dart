import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_endpoints.dart';
import '../models/book.dart';

class BookService {
  static Future<List<Book>> fetchBestSellers() async {
    try {
      final response = await http.get(Uri.parse(ApiEndpoints.bestSellers));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      }
    } catch (e) {
      print('DEBUG: Lỗi fetchBestSellers: $e');
    }

    // fallback mock if API không hoạt động
    return [
      Book(
        id: 1,
        title: 'Flutter for Beginners',
        author: 'John Doe',
        imageUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794',
        description: 'An introductory guide to Flutter UI development.',
        price: 12.99,
        rating: 4.5,
        isBestSeller: true,
        soldCount: 21,
        stock: 12,
        categoryId: 1,
      ),
      Book(
        id: 2,
        title: 'Dart in Action',
        author: 'Jane Smith',
        imageUrl: 'https://images.unsplash.com/photo-1529070538774-1843cb3265df',
        description: 'Comprehensive Dart language manual.',
        price: 19.99,
        rating: 4.8,
        isBestSeller: true,
        soldCount: 50,
        stock: 5,
        categoryId: 1,
      ),
    ];
  }

  static Future<List<Book>> searchBooks(String q) async {
    try {
      final uri = Uri.parse(ApiEndpoints.books).replace(
        queryParameters: q.isNotEmpty ? {'search': q} : null,
      );
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        if (json is List) {
          return json.map((e) => Book.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print('DEBUG: Lỗi searchBooks: $e');
    }

    // fallback local filtered mock
    final all = await fetchBestSellers();
    if (q.isEmpty) return all;
    final lower = q.toLowerCase();
    return all
        .where((b) => b.title.toLowerCase().contains(lower))
        .toList(growable: false);
  }

  static Future<Book?> getBookById(int id) async {
    try {
      final res = await http.get(Uri.parse('${ApiEndpoints.books}/$id'));
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        if (json is Map<String, dynamic>) {
          return Book.fromJson(json);
        }
      }
    } catch (e) {
      print('DEBUG: Lỗi getBookById: $e');
    }

    // fallback
    final list = await fetchBestSellers();
    return list.firstWhere((book) => book.id == id, orElse: () => list.first);
  }

  // Giữ lại để tương thích nếu cần
  static Future<List<Book>> getAllBooks({String? search, int? categoryId}) async {
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
}
