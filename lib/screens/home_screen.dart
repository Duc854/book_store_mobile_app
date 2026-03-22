import 'package:flutter/material.dart';
import '../core/routes.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Book>> _bestSellersFuture;
  List<Book> _allBestSellers = [];
  int _currentPage = 1;
  static const int _itemsPerPage = 6;

  @override
  void initState() {
    super.initState();
    _loadBestSellers();
  }

  Future<void> _loadBestSellers() async {
    _bestSellersFuture = BookService.fetchBestSellers();
    final books = await _bestSellersFuture;
    if (!mounted) return;
    setState(() {
      _allBestSellers = books;
    });
  }

  List<Book> _getPaginatedBooks() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _allBestSellers.length) return [];
    return _allBestSellers.sublist(
      startIndex,
      endIndex > _allBestSellers.length ? _allBestSellers.length : endIndex,
    );
  }

  int _getTotalPages() {
    return (_allBestSellers.length / _itemsPerPage).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.products);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Best Sellers',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Book>>(
                future: _bestSellersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || snapshot.data == null) {
                    return const Center(child: Text('Unable to load best sellers'));
                  }
                  final books = _getPaginatedBooks();
                  if (books.isEmpty) {
                    return const Center(child: Text('No best sellers available'));
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.productDetail,
                            arguments: book.id,
                          );
                        },
                        child: Container(
                          width: 170,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: book.imageUrl.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(book.imageUrl,
                                            width: double.infinity,
                                            fit: BoxFit.cover),
                                      )
                                    : Container(
                                        color: Colors.grey.shade200,
                                        child: const Center(
                                            child: Icon(Icons.book,
                                                size: 50, color: Colors.grey)),
                                      ),
                              ),
                              const SizedBox(height: 8),
                              Text(book.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      const TextStyle(fontWeight: FontWeight.bold)),
                              Text(book.author,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text('Price: \$${book.price.toStringAsFixed(2)}'),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemCount: books.length,
                  );
                },
              ),
            ),
            if (_allBestSellers.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _currentPage > 1
                          ? () => setState(() => _currentPage--)
                          : null,
                      child: const Text('← Previous'),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Page $_currentPage / ${_getTotalPages()}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _currentPage < _getTotalPages()
                          ? () => setState(() => _currentPage++)
                          : null,
                      child: const Text('Next →'),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.list),
                label: const Text('View all products'),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.products);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
