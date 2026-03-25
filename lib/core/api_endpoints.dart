class ApiEndpoints {
  static const String baseUrl = 'https://localhost:7128/api';

  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';

  // Profile
  static const String profile = '$baseUrl/User/profile';

  // Books
  static const String books = '$baseUrl/books';
  static const String categories = '$baseUrl/books/categories';
  static const String bestSellers = '$baseUrl/books/best-sellers';

  // Cart
  static const String cart = '$baseUrl/cart';
  static const String addToCart = '$baseUrl/cart/add';
  static const String updateCart = '$baseUrl/cart/update-quantity';
  static const String checkout = '$baseUrl/cart/checkout';

  // Admin
  static const String adminCategory = '$baseUrl/Categories';
  static const String adminBook = '$baseUrl/admin/books';
  static const String adminDashboard = '$baseUrl/admin';
}
