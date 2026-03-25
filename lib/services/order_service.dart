import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_endpoints.dart';
import '../models/order.dart';
import 'auth_service.dart';

class OrderService {
  static Future<Map<String, String>> _getAuthHeaders() async {
    final authService = AuthService();
    final token = await authService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Future<List<Order>> getMyOrders() async {
    try {
      final headers = await _getAuthHeaders();
      final res = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/Tracking/my-orders'),
        headers: headers,
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is List) {
          return data.map((e) => Order.fromJson(Map<String, dynamic>.from(e))).toList();
        }
      }
    } catch (_) {}

    // Return an empty list if the backend call fails or returns unexpected data
    return [];
  }

  static Future<Order?> getOrderById(int id) async {
    try {
      final headers = await _getAuthHeaders();
      final res = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/Tracking/my-orders/$id'),
        headers: headers,
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is Map<String, dynamic>) {
          return Order.fromJson(data);
        }
      }
    } catch (_) {}

    final orders = await getMyOrders();
    for (final order in orders) {
      if (order.id == id) {
        return order;
      }
    }
    return null;
  }

  static Future<bool> updateOrderStatus(int id, String status) async {
    try {
      final headers = await _getAuthHeaders();
      final res = await http.patch(
        Uri.parse('${ApiEndpoints.baseUrl}/Tracking/update-status/$id'),
        headers: headers,
        body: jsonEncode({'status': status}),
      );
      return res.statusCode == 200 || res.statusCode == 204;
    } catch (_) {
      return false;
    }
  }
}
