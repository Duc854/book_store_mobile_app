import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartService _cartService = CartService();
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  List<CartItem> _cartItems = [];
  bool _isLoading = true;
  bool _isCheckingOut = false;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    final items = await _cartService.getCart();
    setState(() {
      _cartItems = items;
      _isLoading = false;
    });
  }

  double get _totalAmount {
    return _cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  Future<void> _handleCheckout() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCheckingOut = true);
    final result = await _cartService.checkout();
    setState(() => _isCheckingOut = false);

    if (result['success']) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(result['data']['message'] ?? 'Order successful!'),
              const SizedBox(height: 10),
              const Text(
                'Shipping information:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Address: ${_addressController.text}'),
              Text('Phone: ${_phoneController.text}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                Navigator.of(context).pop(); // Quay lại giỏ hàng
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message'] ?? 'App error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'Shipping address',
                            prefixIcon: Icon(Icons.location_on),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please input address';
                            if (value.length < 10)
                              return 'Address to short, please input more detail';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone number',
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please input phone number';
                            if (!RegExp(r'^[0-9]+$').hasMatch(value))
                              return 'Phone number only contain digit';
                            if (value.length < 10 || value.length > 11)
                              return 'Phone number must be 10 or 11 characters';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Order script',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        return ListTile(
                          leading: Image.network(
                            item.imageUrl,
                            width: 40,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.book),
                          ),
                          title: Text(item.title),
                          subtitle: Text('${item.quantity} x ${item.price} Đ'),
                          trailing: Text('${item.quantity * item.price} Đ'),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total money:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '$_totalAmount Đ',
                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge?.copyWith(fontSize: 22),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isCheckingOut ? null : _handleCheckout,
                            child: _isCheckingOut
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text('Confirm checkout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
