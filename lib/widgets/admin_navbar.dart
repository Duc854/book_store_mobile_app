import 'package:flutter/material.dart';
import '../screens/admin_books_screen.dart';
import '../screens/admin_category_screen.dart';
import '../screens/admin_dashboard.dart';

class AdminNavbar extends StatefulWidget {
  const AdminNavbar({super.key});

  @override
  State<AdminNavbar> createState() => _AdminNavbarState();
}

class _AdminNavbarState extends State<AdminNavbar> {

  int index=0;

  final screens=[
    const AdminDashboard(),
    const AdminBooksScreen(),
    const AdminCategoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: screens[index],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: index,

        onTap:(i){
          setState(() {
            index=i;
          });
        },

        items: const [

          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: "Books"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: "Category"
          ),
        ],
      ),
    );
  }
}