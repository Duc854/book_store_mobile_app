import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_endpoints.dart';
import '../models/book.dart';

class BookService {
  static Future<List<Book>> fetchBestSellers() async {
    try {
      final res =
          await http.get(Uri.parse('${ApiEndpoints.baseUrl}/Books/best-sellers'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is List) {
          return data.map((e) => Book.fromJson(e)).toList();
        }
      }
    } catch (_) {}

    // fallback mock if API không hoạt động
    return [
      Book(
        id: 1,
        title: 'Flutter for Beginners',
        author: 'John Doe',
        imageUrl:
            'https://images.unsplash.com/photo-1512820790803-83ca734da794',
        description: 'An introductory guide to Flutter UI development.',
        price: 12.99,
        rating: 1,
        isBestSeller: false,
        soldCount: 21,
        stock: 12,
        categoryId: 1,
      ),
      Book(
        id: 2,
        title: 'Dart in Action',
        author: 'Jane Smith',
        imageUrl:
            'https://images.unsplash.com/photo-1529070538774-1843cb3265df',
        description: 'Comprehensive Dart language manual.',
        price: 19.99,
        rating: 1,
        isBestSeller: false,
        soldCount: 1,
        stock: 1,
        categoryId: 1,
      ),
    ];
  }

  static Future<List<Book>> getAllBooks() async {
    try {
      final res = await http.get(Uri.parse('${ApiEndpoints.baseUrl}/Books'));
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        if (json is List) {
          return json.map((e) => Book.fromJson(e)).toList();
        }
      }
    } catch (_) {}

    // fallback mock if API không hoạt động
    return await fetchBestSellers();
  }

  static Future<List<Book>> searchBooks(String q) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.baseUrl}/Books').replace(
        queryParameters: q.isNotEmpty ? {'search': q} : null,
      );
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        if (json is List) {
          return json.map((e) => Book.fromJson(e)).toList();
        }
      }
    } catch (_) {}

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
      final res = await http.get(Uri.parse('${ApiEndpoints.baseUrl}/Books/$id'));
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        if (json is Map<String, dynamic>) {
          return Book.fromJson(json);
        }
      }
    } catch (_) {}

    // fallback
    final list = await fetchBestSellers();
    return list.firstWhere((book) => book.id == id, orElse: () => list.first);
  }
}
