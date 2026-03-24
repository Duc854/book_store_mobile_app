import 'package:book_store_mobile_app/core/routes.dart';
import 'package:book_store_mobile_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:book_store_mobile_app/screens/admin_books_screen.dart';
import 'package:book_store_mobile_app/screens/admin_category_screen.dart';

import 'themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book App',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
    );
  }
}
