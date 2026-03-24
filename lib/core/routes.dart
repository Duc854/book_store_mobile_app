import 'package:flutter/material.dart';
import '../screens/screens.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const SignupScreen(),
      home: (context) => const HomeScreen(),
    };
  }
}
