import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final int bookId;
  const ProductDetailScreen({super.key, required this.bookId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Book?> _bookFuture;

  @override
  void initState() {
    super.initState();
    _bookFuture = BookService.getBookById(widget.bookId);
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
                    style: Theme.of(context).textTheme.headlineSmall),
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
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Added to cart (not implemented yet)')));
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Add to Cart'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
