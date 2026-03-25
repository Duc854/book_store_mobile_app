import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class MyOrderDetailScreen extends StatefulWidget {
  final int orderId;
  const MyOrderDetailScreen({super.key, required this.orderId});

  @override
  _MyOrderDetailScreenState createState() => _MyOrderDetailScreenState();
}

class _MyOrderDetailScreenState extends State<MyOrderDetailScreen> {
  late Future<Order?> _orderFuture;

  @override
  void initState() {
    super.initState();
    _orderFuture = OrderService.getOrderById(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Detail')),
      body: FutureBuilder<Order?>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Unable to load order detail'));
          }

          final order = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order #${order.id}', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Status: ${order.status}'),
                Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                Text('Created at: ${order.orderDate.toLocal()}'),
                const SizedBox(height: 16),
                const Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: order.orderItems.length,
                    itemBuilder: (context, index) {
                      final item = order.orderItems[index];
                      return ListTile(
                        title: Text(item.bookTitle ?? 'Book #${item.bookId}'),
                        subtitle: Text('Qty: ${item.quantity}  •  \$${item.unitPrice.toStringAsFixed(2)}'),
                        trailing: Text('\$${(item.unitPrice * item.quantity).toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
