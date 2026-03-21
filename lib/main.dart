import 'package:flutter/material.dart';
import 'package:book_store_mobile_app/screens/admin_books_screen.dart';
import 'package:book_store_mobile_app/screens/admin_category_screen.dart';

import 'themes/app_theme.dart';
import 'screens/admin_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Book Store",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AdminBooksScreen(),
    );
  }
}