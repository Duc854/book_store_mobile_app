import 'package:book_store_mobile_app/models/category.dart';
import 'package:book_store_mobile_app/services/admin_category_service.dart';
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

  List<int> pageSizeOptions = [5, 10, 20];
  int get totalPages => (filteredBooks.length / pageSize).ceil();

  List<String> authors = ["All"];
  String selectedAuthor = "All";

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

  authors = ["All"];
  authors.addAll(books.map((b) => b.author).toSet().toList());

  applyFilter();

  setState(() {
    loading = false;
  });
}

  void applyFilter() {
    filteredBooks = books.where((b) {
      final matchAuthor = selectedAuthor == "All"
          ? true
          : b.author == selectedAuthor;

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

  void showBookDialog({Book? book}) async {
    List<Category> categories = await AdminCategoryService.getCategories();

    final title = TextEditingController(text: book?.title);
    final author = TextEditingController(text: book?.author);
    final price = TextEditingController(text: book?.price.toString());
    final stock = TextEditingController(text: book?.stock.toString());
    final image = TextEditingController(text: book?.imageUrl);
    final description = TextEditingController(text: book?.description);

    int? selectedCategoryId =
        book?.categoryId ??
        (categories.isNotEmpty ? categories.first.id : null);
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(book == null ? "Add Book" : "Edit Book"),

              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ===== TITLE =====
                      TextFormField(
                        controller: title,
                        decoration: InputDecoration(labelText: "Title"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Title không được để trống";
                          }
                          if (value.length < 3) {
                            return "Title phải ≥ 3 ký tự";
                          }
                          return null;
                        },
                      ),

                      // ===== AUTHOR =====
                      TextFormField(
                        controller: author,
                        decoration: InputDecoration(labelText: "Author"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Author không được để trống";
                          }
                          return null;
                        },
                      ),

                      // ===== DESCRIPTION =====
                      TextFormField(
                        controller: description,
                        decoration: InputDecoration(labelText: "Description"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Description không được để trống";
                          }
                          return null;
                        },
                      ),

                      // ===== PRICE =====
                      TextFormField(
                        controller: price,
                        decoration: InputDecoration(labelText: "Price"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Price không được để trống";
                          }

                          final p = double.tryParse(value);
                          if (p == null) {
                            return "Price phải là số";
                          }

                          if (p <= 0) {
                            return "Price phải > 0";
                          }

                          return null;
                        },
                      ),

                      // ===== STOCK =====
                      TextFormField(
                        controller: stock,
                        decoration: InputDecoration(labelText: "Stock"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Stock không được để trống";
                          }

                          final s = int.tryParse(value);
                          if (s == null) {
                            return "Stock phải là số nguyên";
                          }

                          if (s < 0) {
                            return "Stock không được âm";
                          }

                          return null;
                        },
                      ),

                      // ===== IMAGE URL =====
                      TextFormField(
                        controller: image,
                        decoration: InputDecoration(labelText: "Image URL"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Image URL không được để trống";
                          }

                          final uri = Uri.tryParse(value);
                          if (uri == null || !uri.isAbsolute) {
                            return "URL không hợp lệ";
                          }

                          return null;
                        },
                      ),

                      // ===== CATEGORY =====
                      DropdownButtonFormField<int>(
                        value: selectedCategoryId,
                        decoration: InputDecoration(labelText: "Category"),
                        items: categories.map((c) {
                          return DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedCategoryId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Vui lòng chọn category";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    // 🔥 VALIDATE FORM
                    if (!_formKey.currentState!.validate()) return;

                    Book newBook = Book(
                      id: book != null ? book.id : 0,
                      title: title.text,
                      author: author.text,
                      description: description.text,
                      price: double.parse(price.text),
                      imageUrl: image.text,
                      stock: int.parse(stock.text),
                      categoryId: selectedCategoryId!,
                      rating: 0,
                      isBestSeller: false,
                      soldCount: 0,
                    );

                    try {
                      if (book == null) {
                        await AdminBookService.createBook(newBook);
                      } else {
                        await AdminBookService.updateBook(newBook);
                      }

                      Navigator.pop(context);
                      await loadBooks();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            book == null
                                ? "Thêm thành công"
                                : "Cập nhật thành công",
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
                    }
                  },
                  child: Text("Save"),
                ),
              ],
            );
          },
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
                      // ===== Chọn số sách hiển thị =====
                      Row(
                        children: [
                          const Text("Show: "),
                          DropdownButton<int>(
                            value: pageSize,
                            items: pageSizeOptions.map((size) {
                              return DropdownMenuItem(
                                value: size,
                                child: Text("$size per page"),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  pageSize = value;
                                  currentPage = 1;
                                });
                              }
                            },
                          ),
                          const SizedBox(width: 20),
                          // ===== Filter Author =====
                          const Text("Author: "),
                          DropdownButton<String>(
                            value: selectedAuthor,
                            items: authors.map((a) {
                              return DropdownMenuItem(value: a, child: Text(a));
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedAuthor = value;
                                  applyFilter();
                                });
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ===== Search Title =====
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

                      // ===== Sort Price =====
                      Row(
                        children: [
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
                      // Prev button
                      ElevatedButton(
                        onPressed: prevPage,
                        child: const Text("Prev"),
                      ),

                      const SizedBox(width: 20),

                      // Page info
                      Text("Page $currentPage / $totalPages"),

                      const SizedBox(width: 20),

                      // Next button
                      ElevatedButton(
                        onPressed: nextPage,
                        child: const Text("Next"),
                      ),

                      const SizedBox(width: 20),
                     
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
