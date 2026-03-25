import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../core/routes.dart';

class MainSpeedDial extends StatelessWidget {
  final VoidCallback? onRefresh;

  const MainSpeedDial({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SpeedDial(
      icon: Icons.menu,
      activeIcon: Icons.close,
      backgroundColor: colorScheme.primary,
      foregroundColor: Colors.white,
      buttonSize: const Size(56.0, 56.0),
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      children: [
        if (onRefresh != null)
          SpeedDialChild(
            child: const Icon(Icons.refresh),
            backgroundColor: Colors.grey,
            label: 'Làm mới',
            onTap: onRefresh,
          ),
        SpeedDialChild(
          child: const Icon(Icons.local_shipping),
          backgroundColor: Colors.teal,
          label: 'Theo dõi',
          onTap: () {
            if (ModalRoute.of(context)?.settings.name != AppRoutes.trackingOrder) {
              Navigator.pushNamed(context, AppRoutes.trackingOrder);
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
