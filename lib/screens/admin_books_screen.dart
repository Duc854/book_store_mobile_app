import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/admin_book_service.dart';

class AdminBooksScreen extends StatefulWidget {
  const AdminBooksScreen({super.key});

  @override
  State<AdminBooksScreen> createState() => _AdminBooksScreenState();
}

class _AdminBooksScreenState extends State<AdminBooksScreen> {
  List<Book> books = [];
  List<Book> filteredBooks = [];

  bool loading = true;

  String authorFilter = "";
  String titleSearch = "";

  bool sortAsc = true;

  int currentPage = 1;
  int pageSize = 5;

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    books = await AdminBookService.getBooks();

    applyFilter();

    setState(() {
      loading = false;
    });
  }

  void applyFilter() {
    filteredBooks = books.where((b) {
      final matchAuthor = b.author.toLowerCase().contains(
        authorFilter.toLowerCase(),
      );

      final matchTitle = b.title.toLowerCase().contains(
        titleSearch.toLowerCase(),
      );

      return matchAuthor && matchTitle;
    }).toList();

    filteredBooks.sort(
      (a, b) =>
          sortAsc ? a.price.compareTo(b.price) : b.price.compareTo(a.price),
    );

    currentPage = 1;
  }

  List<Book> get paginatedBooks {
    int start = (currentPage - 1) * pageSize;
    int end = start + pageSize;

    if (end > filteredBooks.length) end = filteredBooks.length;

    return filteredBooks.sublist(start, end);
  }

  void nextPage() {
    if (currentPage * pageSize < filteredBooks.length) {
      setState(() {
        currentPage++;
      });
    }
  }

  void prevPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
    }
  }

  Future<void> deleteBook(int id) async {
    await AdminBookService.deleteBook(id);

    await loadBooks();
  }

  void showBookDialog({Book? book}) {
    bool saving = false;
    TextEditingController title = TextEditingController(text: book?.title);
    TextEditingController author = TextEditingController(text: book?.author);
    TextEditingController price = TextEditingController(
      text: book?.price.toString() ?? "",
    );
    TextEditingController stock = TextEditingController(
      text: book?.stock.toString(),
    );
    TextEditingController image = TextEditingController(text: book?.imageUrl);
    TextEditingController category = TextEditingController(
      text: book?.categoryId.toString(),
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(book == null ? "Add Book" : "Edit Book"),

          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: title,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: author,
                  decoration: const InputDecoration(labelText: "Author"),
                ),
                TextField(
                  controller: price,
                  decoration: const InputDecoration(labelText: "Price"),
                ),
                TextField(
                  controller: stock,
                  decoration: const InputDecoration(labelText: "Stock"),
                ),
                TextField(
                  controller: image,
                  decoration: const InputDecoration(labelText: "Image URL"),
                ),
                TextField(
                  controller: category,
                  decoration: const InputDecoration(labelText: "CategoryId"),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: saving
                  ? null
                  : () async {
                      setState(() {
                        saving = true;
                      });

                      Book newBook = Book(
                        id: book?.id,
                        title: title.text,
                        author: author.text,
                        description: "",
                        price: double.parse(price.text),
                        imageUrl: image.text,
                        stock: int.parse(stock.text),
                        categoryId: int.parse(category.text),
                        isBestSeller: false,
                        soldCount: 0,
                      );

                      if (book == null) {
                        await AdminBookService.createBook(newBook);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Book created successfully"),
                          ),
                        );
                      } else {
                        await AdminBookService.updateBook(newBook);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Book updated successfully"),
                          ),
                        );
                      }

                      Navigator.pop(context);

                      await loadBooks();

                      setState(() {
                        saving = false;
                      });
                    },

              child: saving
                  ? const CircularProgressIndicator()
                  : const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Books")),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showBookDialog(),
        child: const Icon(Icons.add),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),

                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: "Search by Title",
                        ),

                        onChanged: (value) {
                          titleSearch = value;

                          applyFilter();

                          setState(() {});
                        },
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: "Filter by Author",
                              ),

                              onChanged: (value) {
                                authorFilter = value;

                                applyFilter();

                                setState(() {});
                              },
                            ),
                          ),

                          const SizedBox(width: 10),

                          ElevatedButton(
                            onPressed: () {
                              sortAsc = !sortAsc;

                              applyFilter();

                              setState(() {});
                            },

                            child: Text(sortAsc ? "Price ↑" : "Price ↓"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: paginatedBooks.length,

                    itemBuilder: (context, index) {
                      final book = paginatedBooks[index];

                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            book.imageUrl,
                            width: 50,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.book),
                          ),

                          title: Text(book.title),

                          subtitle: Text("${book.author} | \$${book.price}"),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => showBookDialog(book: book),
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Confirm Delete"),
                                      content: const Text(
                                        "Are you sure you want to delete this book?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancel"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            Navigator.pop(context);

                                            await deleteBook(book.id!);

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Book deleted successfully",
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      ElevatedButton(
                        onPressed: prevPage,
                        child: const Text("Prev"),
                      ),

                      const SizedBox(width: 20),

                      Text("Page $currentPage"),

                      const SizedBox(width: 20),

                      ElevatedButton(
                        onPressed: nextPage,
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
