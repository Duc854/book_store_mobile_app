import 'package:book_store_mobile_app/widgets/main_speed_dial.dart';
import 'package:flutter/material.dart';

class CloneTrackingOrderScreen extends StatelessWidget {
  const CloneTrackingOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_shipping_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'Hello World',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '(Tính năng đang được phát triển)',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: const MainSpeedDial(),
    );
  }
}
