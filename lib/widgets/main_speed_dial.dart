import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../core/routes.dart';

class MainSpeedDial extends StatefulWidget {
  final VoidCallback? onRefresh;

  const MainSpeedDial({super.key, this.onRefresh});

  @override
  State<MainSpeedDial> createState() => _MainSpeedDialState();
}

class _MainSpeedDialState extends State<MainSpeedDial> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SpeedDial(
      icon: Icons.menu,
      activeIcon: Icons.close,
      // Hiệu ứng làm mờ khi chưa bấm (khi _isOpen là false)
      backgroundColor: colorScheme.primary.withAlpha(_isOpen ? 255 : 180),
      foregroundColor: Colors.white.withAlpha(_isOpen ? 255 : 180),
      buttonSize: const Size(56.0, 56.0),
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => setState(() => _isOpen = true),
      onClose: () => setState(() => _isOpen = false),
      children: [
        if (widget.onRefresh != null)
          SpeedDialChild(
            child: const Icon(Icons.refresh),
            backgroundColor: Colors.grey,
            label: 'Làm mới',
            onTap: widget.onRefresh,
          ),
        SpeedDialChild(
          child: const Icon(Icons.local_shipping),
          backgroundColor: Colors.teal,
          label: 'Đơn hàng của tôi',
          onTap: () {
            if (ModalRoute.of(context)?.settings.name != AppRoutes.myOrders) {
              Navigator.pushNamed(context, AppRoutes.myOrders);
            }
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.person),
          backgroundColor: Colors.blue,
          label: 'Tài khoản',
          onTap: () {
            if (ModalRoute.of(context)?.settings.name != AppRoutes.profile) {
              Navigator.pushNamed(context, AppRoutes.profile);
            }
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.shopping_cart),
          backgroundColor: Colors.orange,
          label: 'Giỏ hàng',
          onTap: () {
            if (ModalRoute.of(context)?.settings.name != AppRoutes.cart) {
              Navigator.pushNamed(context, AppRoutes.cart);
            }
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.search),
          backgroundColor: Colors.green,
          label: 'Sản phẩm',
          onTap: () {
            if (ModalRoute.of(context)?.settings.name != AppRoutes.products) {
              Navigator.pushNamed(context, AppRoutes.products);
            }
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.home),
          backgroundColor: Colors.purple,
          label: 'Trang chủ',
          onTap: () {
            if (ModalRoute.of(context)?.settings.name != AppRoutes.home) {
              Navigator.pushNamed(context, AppRoutes.home);
            }
          },
        ),
      ],
    );
  }
}
