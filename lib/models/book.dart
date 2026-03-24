class Book {
  final int id;
  final String title;
  final String author;
  final String imageUrl;
  final String description;
  final double price;
  final double rating;

  final bool isBestSeller;
  final int soldCount;
  final int stock;
  final int categoryId;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.rating,
    required this.isBestSeller,
    required this.soldCount,
    required this.stock,
    required this.categoryId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,

      title: json['title']?.toString() ?? 'No title',
      author: json['author']?.toString() ?? 'Unknown',
      imageUrl: json['imageUrl']?.toString() ?? '',
      description: json['description']?.toString() ?? '',

      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse('${json['price']}') ?? 0.0,

      // nếu BE chưa có rating thì để default 0
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : double.tryParse('${json['rating']}') ?? 0.0,

      isBestSeller: json['isBestSeller'] == true ||
          json['isBestSeller']?.toString().toLowerCase() == 'true',

      soldCount: json['soldCount'] is int
          ? json['soldCount']
          : int.tryParse('${json['soldCount']}') ?? 0,

      stock: json['stock'] is int
          ? json['stock']
          : int.tryParse('${json['stock']}') ?? 0,

      categoryId: json['categoryId'] is int
          ? json['categoryId']
          : int.tryParse('${json['categoryId']}') ?? 0,
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