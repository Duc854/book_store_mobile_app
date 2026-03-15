import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class AdminBookService {

  static const baseUrl = "http://localhost:7128/api/admin/books";

  static Future<List<Book>> getBooks() async {

    final res = await http.get(Uri.parse(baseUrl));

    List data = jsonDecode(res.body);

    return data.map((e)=>Book.fromJson(e)).toList();
  }

  static Future<void> createBook(Book book) async {

    await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode(book.toJson()),
    );

  }

  static Future<void> updateBook(Book book) async {

    await http.put(
      Uri.parse("$baseUrl/${book.id}"),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode(book.toJson()),
    );
  }

  static Future<void> deleteBook(int id) async {

    await http.delete(Uri.parse("$baseUrl/$id"));
  }
}