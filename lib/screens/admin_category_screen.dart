import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/admin_category_service.dart';

class AdminCategoryScreen extends StatefulWidget {

  const AdminCategoryScreen({super.key});

  @override
  State<AdminCategoryScreen> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen>{

  List<Category> categories=[];

  void loadCategories() async{

    categories=await AdminCategoryService.getCategories();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Manage Categories"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(

        itemCount: categories.length,

        itemBuilder:(context,index){

          final c=categories[index];

          return Card(

            child: ListTile(

              title: Text(c.name),

              subtitle: Text(c.description),

              trailing: IconButton(

                icon: const Icon(Icons.delete,color: Colors.red),

                onPressed: (){
                  AdminCategoryService.deleteCategory(c.id!);
                  loadCategories();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}