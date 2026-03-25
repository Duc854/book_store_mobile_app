class CartItem {
  final int bookId;
  final String title;
  final double price;
  final String imageUrl;
  int quantity;
  final int stock;

  CartItem({
    required this.bookId,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.stock,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      bookId: json['bookId'],
      title: json['title'] ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      quantity: json['quantity'] ?? 1,
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'stock': stock,
    };
  }
}
