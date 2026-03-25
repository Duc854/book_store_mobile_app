import 'package:book_store_mobile_app/widgets/main_speed_dial.dart';
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

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.lightGreen;
      case 'shipping':
        return Colors.cyan;
      case 'success':
        return Colors.blue;
      case 'cancelled':
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusChip(String label, String currentStatus) {
    final isActive = currentStatus.toLowerCase() == label.toLowerCase();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? _statusColor(label).withOpacity(0.20) : Colors.grey[200],
        border: Border.all(
          color: isActive ? _statusColor(label) : Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label[0].toUpperCase() + label.substring(1),
        style: TextStyle(
          color: isActive ? _statusColor(label) : Colors.grey.shade600,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
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
          final currentStatus = order.status;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.id}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStatusChip('pending', currentStatus),
                    _buildStatusChip('confirmed', currentStatus),
                    _buildStatusChip('shipping', currentStatus),
                    _buildStatusChip('success', currentStatus),
                    _buildStatusChip('cancelled', currentStatus),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Current status: ${currentStatus[0].toUpperCase()}${currentStatus.substring(1)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                Text('Created at: ${order.orderDate.toLocal()}'),
                const SizedBox(height: 16),
                const Text(
                  'Items',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: order.orderItems.length,
                    itemBuilder: (context, index) {
                      final item = order.orderItems[index];
                      return ListTile(
                        title: Text(item.bookTitle ?? 'Book #${item.bookId}'),
                        subtitle: Text(
                          'Qty: ${item.quantity}  •  \$${item.unitPrice.toStringAsFixed(2)}',
                        ),
                        trailing: Text(
                          '\$${(item.unitPrice * item.quantity).toStringAsFixed(2)}',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: MainSpeedDial(),
    );
  }
}
