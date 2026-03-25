import 'package:book_store_mobile_app/screens/profile_screen.dart';
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
  static const String admin = '/admin';
  static const String profile = '/profile';
  static const String myOrders = '/my-orders';
  static const String myOrderDetail = '/my-order-detail';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const SignupScreen(),
      home: (context) => const HomeScreen(),
      products: (context) => const ProductListScreen(),
      admin: (context) => const AdminNavbar(),
      profile: (context) => const ProfileScreen(),
      myOrders: (context) => const MyOrderScreen(),
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

    if (settings.name == myOrderDetail) {
      final orderId = settings.arguments as int?;
      if (orderId != null) {
        return MaterialPageRoute(
          builder: (context) => MyOrderDetailScreen(orderId: orderId),
          settings: settings,
        );
      }
    }

    return null;
  }
}
