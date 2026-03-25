import 'package:flutter/material.dart';
import '../core/routes.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();
  List<Book> _allBooks = [];
  bool _isLoading = true;
  int _currentPage = 1;
  static const int _itemsPerPage = 6;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks([String query = '']) async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
    });
    final books = query.isEmpty
        ? await BookService.getAllBooks()
        : await BookService.searchBooks(query);
    if (!mounted) return;
    setState(() {
      _allBooks = books;
      _isLoading = false;
    });
  }

  List<Book> _getPaginatedBooks() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    if (startIndex >= _allBooks.length) return [];
    return _allBooks.sublist(
      startIndex,
      endIndex > _allBooks.length ? _allBooks.length : endIndex,
    );
  }

  int _getTotalPages() {
    return (_allBooks.length / _itemsPerPage).ceil();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = _getTotalPages();
    final paginatedBooks = _getPaginatedBooks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search books by name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) => _loadBooks(value.trim()),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _allBooks.isEmpty
                      ? const Center(child: Text('No matching books'))
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                          itemCount: paginatedBooks.length,
                          itemBuilder: (context, index) {
                            final book = paginatedBooks[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.productDetail,
                                  arguments: book.id,
                                );
                              },
                              child: Card(
                                elevation: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: book.imageUrl.isNotEmpty
                                          ? Image.network(book.imageUrl,
                                              width: double.infinity,
                                              fit: BoxFit.cover)
                                          : Container(
                                              color: Colors.grey.shade200,
                                              child: const Center(
                                                child: Icon(Icons.book,
                                                    size: 40, color: Colors.grey),
                                              ),
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(book.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              )),
                                          const SizedBox(height: 4),
                                          Text(book.author,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11,
                                              )),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '\$${book.price.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(Icons.star,
                                                      color: Colors.amber,
                                                      size: 14),
                                                  Text(
                                                    book.rating
                                                        .toStringAsFixed(1),
                                                    style: const TextStyle(
                                                        fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
            const SizedBox(height: 12),
            if (_allBooks.isNotEmpty)
              Row(
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
                    'Page $_currentPage / $totalPages',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _currentPage < totalPages
                        ? () => setState(() => _currentPage++)
                        : null,
                    child: const Text('Next →'),
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () => _loadBooks(_searchController.text.trim()),
      ),
    );
  }
}
