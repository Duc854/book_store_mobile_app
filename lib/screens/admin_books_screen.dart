import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/admin_book_service.dart';

class AdminBooksScreen extends StatefulWidget {

  const AdminBooksScreen({super.key});

  @override
  State<AdminBooksScreen> createState() => _AdminBooksScreenState();
}

class _AdminBooksScreenState extends State<AdminBooksScreen>{

  List<Book> books=[];

  void loadBooks() async{

    books=await AdminBookService.getBooks();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Manage Books"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(

        itemCount: books.length,

        itemBuilder:(context,index){

          final book=books[index];

          return Card(

            child: ListTile(

              leading: Image.network(book.imageUrl,width:50),

              title: Text(book.title),

              subtitle: Text("\$${book.price}"),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {},
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete,color: Colors.red),
                    onPressed: (){
                      AdminBookService.deleteBook(book.id!);
                      loadBooks();
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}