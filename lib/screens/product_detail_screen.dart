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
        content: Text(success ? 'Added "${book.title}" into cart' : 'Error when add to cart'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: FutureBuilder<Book?>(
        future: _bookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Unable to load book information.'));
          }
          final book = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (book.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(book.imageUrl,
                        height: 240, fit: BoxFit.cover),
                  )
                else
                  const Icon(Icons.book, size: 120),
                const SizedBox(height: 16),
                Text(book.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Author: ${book.author}',
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(book.rating.toStringAsFixed(1)),
                  const SizedBox(width: 16),
                  Text('Price: \$${book.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 16),
                Text('Description', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(book.description),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isAdding ? null : () => _addToCart(book),
                    icon: _isAdding 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.shopping_cart),
                    label: Text(_isAdding ? 'Adding...' : 'Add to Cart'),
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
