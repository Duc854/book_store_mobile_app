import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class AdminBookService {

  static const String baseUrl = "https://localhost:7128/api/admin/books";

  static Future<List<Book>> getBooks() async {

    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      return data.map((e) => Book.fromJson(e)).toList();

    } else {

      throw Exception("Failed to load books");
    }
  }

  static Future<void> createBook(Book book) async {

  final body = {
    "title": book.title,
    "author": book.author,
    "description": book.description,
    "price": book.price,
    "imageUrl": book.imageUrl,
    "isBestSeller": book.isBestSeller,
    "soldCount": book.soldCount,
    "stock": book.stock,
    "categoryId": book.categoryId
  };

  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {
      "Content-Type": "application/json"
    },
    body: jsonEncode(body),
  );

  print("STATUS: ${response.statusCode}");
  print("BODY: ${response.body}");

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception("Create book failed");
  }
}

  static Future<void> updateBook(Book book) async {

    final response = await http.put(
      Uri.parse("$baseUrl/${book.id}"),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Update book failed");
    }
  }

  static Future<void> deleteBook(int id) async {

  final response = await http.delete(
    Uri.parse("$baseUrl/$id"),
  );

  if (response.statusCode != 200 && response.statusCode != 204) {
    throw Exception("Delete book failed: ${response.body}");
  }
}
}