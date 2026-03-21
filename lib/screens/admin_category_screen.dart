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

  int currentPage = 1;
  int pageSize = 5;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    categories = await AdminCategoryService.getCategories();
    applyFilter();

    setState(() {
      loading = false;
    });
  }

  // ================= FILTER =================
  void applyFilter() {
    filteredCategories = categories.where((c) {
      return c.name.toLowerCase().contains(search.toLowerCase());
    }).toList();

    filteredCategories.sort((a, b) =>
        sortAsc ? a.name.compareTo(b.name) : b.name.compareTo(a.name));

    currentPage = 1;
  }

  // ================= PAGINATION =================
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

  // ================= DIALOG =================
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
                    const SnackBar(content: Text("Name không được rỗng")),
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
                      content: Text(category == null
                          ? "Thêm thành công"
                          : "Cập nhật thành công"),
                    ),
                  );

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Lỗi: $e")),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // ================= UI =================
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

                // ===== SEARCH + SORT =====
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
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

                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: () {
                          sortAsc = !sortAsc;
                          applyFilter();
                          setState(() {});
                        },
                        child: Text(sortAsc ? "Name ↑" : "Name ↓"),
                      ),
                    ],
                  ),
                ),

                // ===== LIST =====
                Expanded(
                  child: ListView.builder(
                    itemCount: paginatedCategories.length,
                    itemBuilder: (context, index) {
                      final c = paginatedCategories[index];

                      return Card(
                        child: ListTile(
                          title: Text(c.name),
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
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteCategory(c.id!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ===== PAGINATION =====
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