import 'package:book_store_mobile_app/widgets/admin_navbar.dart';
import 'package:flutter/material.dart';
import '../screens/screens.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String products = '/products';
  static const String productDetail = '/product';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String admin = '/admin';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const SignupScreen(),
      home: (context) => const HomeScreen(),
      products: (context) => const ProductListScreen(),
      cart: (context) => const CartScreen(),
      profile: (context) => const ProfileScreen(),
      admin: (context) => const AdminNavbar(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == productDetail) {
      final bookId = settings.arguments as int?;
      if (bookId != null) {
        return MaterialPageRoute(
          builder: (context) => ProductDetailScreen(bookId: bookId),
          settings: settings,
        );
      }
    }
    return null;
  }
}
