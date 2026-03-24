import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import '../services/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final int bookId;
  const ProductDetailScreen({super.key, required this.bookId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Book?> _bookFuture;
  final CartService _cartService = CartService();
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _bookFuture = BookService.getBookById(widget.bookId);
  }

  void _addToCart(Book book) async {
    setState(() => _isAdding = true);
    final success = await _cartService.addToCart(book.id, 1);
    if (!mounted) return;
    setState(() => _isAdding = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Đã thêm "${book.title}" vào giỏ hàng' : 'Lỗi khi thêm vào giỏ hàng'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sách')),
      body: FutureBuilder<Book?>(
        future: _bookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Không thể tải thông tin sách.'));
          }
          final book = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (book.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(book.imageUrl,
                        height: 300, fit: BoxFit.cover),
                  )
                else
                  const Icon(Icons.book, size: 120),
                const SizedBox(height: 20),
                Text(book.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Tác giả: ${book.author}',
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 12),
                Row(children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(book.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 24),
                  Text('Giá: ${book.price.toStringAsFixed(0)} Đ',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red)),
                ]),
                const SizedBox(height: 20),
                Text('Mô tả', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(book.description, style: const TextStyle(fontSize: 15, height: 1.4)),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isAdding ? null : () => _addToCart(book),
                    icon: _isAdding 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.shopping_cart),
                    label: Text(_isAdding ? 'Đang thêm...' : 'Thêm vào giỏ hàng'),
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
