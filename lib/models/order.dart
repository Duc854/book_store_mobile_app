class OrderItem {
  final int id;
  final int orderId;
  final int bookId;
  final int quantity;
  final double unitPrice;
  final String? bookTitle;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.bookId,
    required this.quantity,
    required this.unitPrice,
    this.bookTitle,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      orderId: json['orderId'] is int ? json['orderId'] : int.tryParse('${json['orderId']}') ?? 0,
      bookId: json['bookId'] is int ? json['bookId'] : int.tryParse('${json['bookId']}') ?? 0,
      quantity: json['quantity'] is int ? json['quantity'] : int.tryParse('${json['quantity']}') ?? 0,
      unitPrice: (json['unitPrice'] is num) ? (json['unitPrice'] as num).toDouble() : double.tryParse('${json['unitPrice']}') ?? 0,
      bookTitle: json['book'] != null && json['book'] is Map<String, dynamic>
          ? json['book']['title']?.toString()
          : null,
    );
  }
}

class Order {
  final int id;
  final int userId;
  final DateTime orderDate;
  final double totalAmount;
  final String status;
  final List<OrderItem> orderItems;

  Order({
    required this.id,
    required this.userId,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final list = json['orderItems'];
    return Order(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      userId: json['userId'] is int ? json['userId'] : int.tryParse('${json['userId']}') ?? 0,
      orderDate: DateTime.tryParse(json['orderDate']?.toString() ?? '') ?? DateTime.now(),
      totalAmount: (json['totalAmount'] is num) ? (json['totalAmount'] as num).toDouble() : double.tryParse('${json['totalAmount']}') ?? 0,
      status: json['status']?.toString() ?? 'Pending',
      orderItems: (list is List)
          ? list.map((e) => OrderItem.fromJson(Map<String, dynamic>.from(e))).toList()
          : [],
    );
  }
}
