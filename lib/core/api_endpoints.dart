class ApiEndpoints {
  static const String baseUrl = 'https://localhost:7128/api';

  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String profile = '$baseUrl/User/profile';

  static const String adminCategory = '$baseUrl/Categories';
  static const String adminBook = '$baseUrl/admin/books';
  static const String adminDashboard = '$baseUrl/admin';
}
