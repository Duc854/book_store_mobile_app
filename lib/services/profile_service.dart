import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_endpoints.dart';
import '../services/auth_service.dart';

class ProfileService {
  final AuthService _authService = AuthService();

  // Hàm Get Profile trả về Dynamic để UI tự Map vào Model
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse(ApiEndpoints.profile),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return {"success": true, "data": jsonDecode(response.body)};
      }
      return {
        "success": false,
        "message": "Không thể lấy thông tin: ${response.statusCode}",
      };
    } catch (e) {
      return {"success": false, "message": "Lỗi kết nối: $e"};
    }
  }

  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> updateData,
  ) async {
    try {
      final token = await _authService.getToken();
      final response = await http.put(
        Uri.parse(ApiEndpoints.profile),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateData),
      );

      final result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": result['message'],
          "data": result['data'],
        };
      }
      // Trả về lỗi từ server (ví dụ: sai mật khẩu cũ)
      return {"success": false, "message": result.toString()};
    } catch (e) {
      return {"success": false, "message": "Lỗi hệ thống: $e"};
    }
  }
}
