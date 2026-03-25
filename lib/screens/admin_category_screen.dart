import 'package:book_store_mobile_app/services/admin_category_service.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';

class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  List<Category> categories = [];
  List<Category> filteredCategories = [];

  bool loading = true;

  String search = "";
  bool sortAsc = true;
  bool sortIdAsc = true;
  List<int> pageSizeOptions = [5, 10, 20];
  int get totalPages => (filteredCategories.length / pageSize)
      .ceil()
      .clamp(1, double.infinity)
      .toInt();
  int currentPage = 1;
  int pageSize = 5;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> deleteBook(int id) async {
    await AdminCategoryService.deleteCategory(id);

    await loadCategories();
  }

  Future<void> loadCategories() async {
    categories = await AdminCategoryService.getCategories();
    applyFilter();

    setState(() {
      loading = false;
    });
  }

  void applyFilter() {
    filteredCategories = categories.where((c) {
      return c.name.toLowerCase().contains(search.toLowerCase());
    }).toList();

    filteredCategories.sort((a, b) => a.id!.compareTo(b.id!));

    currentPage = 1;
  }

  List<Category> get paginatedCategories {
    int start = (currentPage - 1) * pageSize;
    int end = start + pageSize;

    if (end > filteredCategories.length) {
      end = filteredCategories.length;
    }

    return filteredCategories.sublist(start, end);
  }

  void nextPage() {
    if (currentPage * pageSize < filteredCategories.length) {
      setState(() => currentPage++);
    }
  }

  void prevPage() {
    if (currentPage > 1) {
      setState(() => currentPage--);
    }
  }

  Future<void> deleteCategory(int id) async {
    await AdminCategoryService.deleteCategory(id);
    await loadCategories();
  }

  void showCategoryDialog({Category? category}) {
    final name = TextEditingController(text: category?.name);
    final description = TextEditingController(text: category?.description);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(category == null ? "Add Category" : "Edit Category"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: description,
                decoration: const InputDecoration(labelText: "Description"),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                if (name.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Name cannot be empty")),
                  );
                  return;
                }

                Category newCat = Category(
                  id: category?.id,
                  name: name.text,
                  description: description.text,
                );

                try {
                  if (category == null) {
                    await AdminCategoryService.createCategory(newCat);
                  } else {
                    await AdminCategoryService.updateCategory(newCat);
                  }

                  Navigator.pop(context);
                  await loadCategories();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        category == null
                            ? "Category added successfully"
                            : "Category updated successfully",
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Categories")),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showCategoryDialog(),
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
                          const SizedBox(width: 10),

                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                sortAsc = !sortAsc;
                                applyFilter();
                              });
                            },
                            child: Text(sortAsc ? "Name ↑" : "Name ↓"),
                          ),
                          const SizedBox(width: 10),

                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                sortIdAsc = !sortIdAsc;
                                filteredCategories.sort(
                                  (a, b) => sortIdAsc
                                      ? a.id!.compareTo(b.id!)
                                      : b.id!.compareTo(a.id!),
                                );
                                currentPage = 1;
                              });
                            },
                            child: Text(sortIdAsc ? "ID ↑" : "ID ↓"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        decoration: const InputDecoration(
                          labelText: "Search category",
                        ),
                        onChanged: (value) {
                          search = value;
                          applyFilter();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: paginatedCategories.length,
                    itemBuilder: (context, index) {
                      final c = paginatedCategories[index];

                      return Card(
                        child: ListTile(
                          title: Text("${c.id} - ${c.name}"),
                          subtitle: Text(c.description),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    showCategoryDialog(category: c),
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
                                        "Are you sure you want to delete this category?",
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
                                            await deleteCategory(c.id!);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Category deleted successfully",
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
                      Text("Page $currentPage / $totalPages"),
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
