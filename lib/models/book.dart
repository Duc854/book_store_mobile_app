class Book {
  final int id;
  final String title;
  final String author;
  final String description;
  final double price;
  final String imageUrl;
  final bool isBestSeller;
  final int soldCount;
  final int stock;
  final int categoryId;

  Book({
    required this.id,
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

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      isBestSeller: json['isBestSeller'] ?? false,
      soldCount: json['soldCount'] ?? 0,
      stock: json['stock'] ?? 0,
      categoryId: json['categoryId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isBestSeller': isBestSeller,
      'soldCount': soldCount,
      'stock': stock,
      'categoryId': categoryId,
    };
  }
}
