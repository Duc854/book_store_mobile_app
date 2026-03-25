import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_endpoints.dart';
import '../models/cart_item.dart';

class CartService {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<CartItem>> getCart() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(Uri.parse(ApiEndpoints.cart), headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => CartItem.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> addToCart(int bookId, int quantity) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(ApiEndpoints.addToCart),
        headers: headers,
        body: jsonEncode({'bookId': bookId, 'quantity': quantity}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateQuantity(int bookId, int quantity) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('${ApiEndpoints.updateCart}?bookId=$bookId&quantity=$quantity'),
        headers: headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> checkout() async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(Uri.parse(ApiEndpoints.checkout), headers: headers);
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối'};
    }
  }
}
