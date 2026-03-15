class CartItem {
  final int bookId;
  final String title;
  final String imageUrl;
  final double price;
  int quantity;
  int stock;

  CartItem({
    required this.bookId,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.stock = 99,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'quantity': quantity,
      'price': price,
    };
  }
}
