import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class MainNavbar extends StatefulWidget {
  const MainNavbar({super.key});

  @override
  State<MainNavbar> createState() => _MainNavbarState();
}

class _MainNavbarState extends State<MainNavbar> {
  int _currentIndex = 0;

  // Placeholder cho các màn hình của Linh và Đức
  // Sau khi họ code xong, thay thế các Center(...) bằng Widget tương ứng
  final List<Widget> _screens = [
    // Tab 0: Trang chủ (Linh)
    const Center(
        child: Text("🏠 Màn Home",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey))),
    // Tab 1: Danh sách sách (Linh)
    const Center(
        child: Text("📚 Danh sách sản phẩm",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey))),
    // Tab 2: Giỏ hàng (Quân)
    const CartScreen(),
    // Tab 3: Tài khoản (Đức)
    const Center(
        child: Text("👤 Tài khoản",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey))),
  ];

  @override
  Widget build(BuildContext context) {
    int cartCount = Provider.of<CartProvider>(context).itemCount;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: 'Trang chủ'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded), label: 'Khám phá'),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart_rounded),
                  if (cartCount > 0)
                    Positioned(
                      right: -8,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          cartCount > 99 ? '99+' : '$cartCount',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ],
              ),
              label: 'Giỏ hàng',
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded), label: 'Tài khoản'),
          ],
        ),
      ),
    );
  }
}
