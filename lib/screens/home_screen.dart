import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import '../services/cart_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BookService _bookService = BookService();
  final CartService _cartService = CartService();
  List<Book> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final books = await _bookService.getAllBooks();
    setState(() {
      _books = books;
      _isLoading = false;
    });
  }

  Future<void> _addToCart(Book book) async {
    final success = await _cartService.addToCart(book.id, 1);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Đã thêm "${book.title}" vào giỏ hàng' : 'Lỗi khi thêm vào giỏ hàng'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBooks,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _books.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.library_books, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('Hiện không có cuốn sách nào.'),
                      const Text('Có thể cơ sở dữ liệu đang trống hoặc lỗi kết nối.'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadBooks,
                        child: const Text('Thử lại / Tải lại'),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: book.imageUrl.isNotEmpty
                            ? Image.network(
                                book.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(child: Icon(Icons.book, size: 50)),
                              )
                            : const Center(child: Icon(Icons.book, size: 50)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              book.author,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${book.price} Đ', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                                  onPressed: () => _addToCart(book),
                                ),
                              ],
                            ),
                          ],
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
