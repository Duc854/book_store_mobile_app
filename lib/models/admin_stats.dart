class AdminStats {

  double totalRevenue;
  int orderCount;
  int userCount;
  List recentOrders;

  AdminStats({
    required this.totalRevenue,
    required this.orderCount,
    required this.userCount,
    required this.recentOrders,
  });

  factory AdminStats.fromJson(Map<String,dynamic> json){

    return AdminStats(
      totalRevenue: (json["totalRevenue"] ?? 0).toDouble(),
      orderCount: json["orderCount"] ?? 0,
      userCount: json["userCount"] ?? 0,
      recentOrders: json["recentOrders"] ?? [],
    );
  }

}