class Book {

  int? id;
  String title;
  String author;
  String description;
  double price;
  String imageUrl;
  bool isBestSeller;
  int soldCount;
  int stock;
  int categoryId;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isBestSeller,
    required this.soldCount,
    required this.stock,
    required this.categoryId,
  });

  factory Book.fromJson(Map<String,dynamic> json){
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      isBestSeller: json['isBestSeller'],
      soldCount: json['soldCount'],
      stock: json['stock'],
      categoryId: json['categoryId'],
    );
  }

  Map<String,dynamic> toJson(){
    return{
      "id":id,
      "title":title,
      "author":author,
      "description":description,
      "price":price,
      "imageUrl":imageUrl,
      "isBestSeller":isBestSeller,
      "soldCount":soldCount,
      "stock":stock,
      "categoryId":categoryId
    };
  }

}