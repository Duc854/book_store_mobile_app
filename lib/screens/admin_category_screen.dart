import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/admin_category_service.dart';

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({super.key});

  @override
  State<AdminCategoryScreen> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen> {
  List<Category> categories = [];
  List<Category> filtered = [];

  String search = "";

  void loadCategories() async {
    categories = await AdminCategoryService.getCategories();

    applyFilter();

    setState(() {});
  }

  void applyFilter() {
    filtered = categories.where((c) {
      return c.name.toLowerCase().contains(search.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void showCategoryDialog({Category? category}) {
    TextEditingController name = TextEditingController(text: category?.name);
    TextEditingController description = TextEditingController(
      text: category?.description,
    );

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
                Category c = Category(
                  id: category?.id,
                  name: name.text,
                  description: description.text,
                );

                try {
                  if (category == null) {
                    await AdminCategoryService.createCategory(c);
                  } else {
                    await AdminCategoryService.updateCategory(c);
                  }

                  Navigator.pop(context);

                  loadCategories();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Saved successfully")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },

              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCategory(Category c) async {
    bool confirm = await showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: const Text("Confirm Delete"),

          content: Text("Delete ${c.name}?"),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await AdminCategoryService.deleteCategory(c.id!);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Category deleted")));

      loadCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Categories")),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showCategoryDialog(),
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),

            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search Category",
                prefixIcon: Icon(Icons.search),
              ),

              onChanged: (value) {
                search = value;

                applyFilter();

                setState(() {});
              },
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,

              itemBuilder: (context, index) {
                final c = filtered[index];

                return Card(
                  child: ListTile(
                    title: Text(c.name),

                    subtitle: Text(c.description),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => showCategoryDialog(category: c),
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteCategory(c),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
