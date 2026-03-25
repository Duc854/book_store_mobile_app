import 'package:book_store_mobile_app/widgets/main_speed_dial.dart';
import 'package:flutter/material.dart';
import '../core/routes.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = OrderService.getMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Unable to load orders'));
          }

          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                child: ListTile(
                  title: Text('Order #${order.id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                      Text('Status: ${order.status}'),
                      Text(
                        'Date: ${order.orderDate.toLocal().toString().split(' ')[0]}',
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.myOrderDetail,
                      arguments: order.id,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: MainSpeedDial(),
    );
  }
}
