import 'package:book_store_mobile_app/services/admin_dashboard_service.dart';
import 'package:book_store_mobile_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool loading = true;

  double revenue = 0;
  int orders = 0;
  int users = 0;

  List recentOrders = [];

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    try {
      final data = await AdminDashboardService.getStats();

      setState(() {
        revenue = (data["totalRevenue"] ?? 0).toDouble();
        orders = data["orderCount"] ?? 0;
        users = data["userCount"] ?? 0;
        recentOrders = data["recentOrders"] ?? [];
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget buildCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Confirm Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await AuthService().logout();
                if (context.mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              }
            },
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Row(
                  children: [
                    buildCard(
                      "Revenue",
                      "\$${revenue.toStringAsFixed(0)}",
                      Icons.attach_money,
                      Colors.green,
                    ),
                    buildCard(
                      "Orders",
                      orders.toString(),
                      Icons.shopping_cart,
                      Colors.blue,
                    ),
                    buildCard(
                      "Users",
                      users.toString(),
                      Icons.people,
                      Colors.orange,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Recent Orders",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: recentOrders.length,
                    itemBuilder: (context, index) {
                      final o = recentOrders[index];

                      return ListTile(
                        leading: const Icon(Icons.receipt),
                        title: Text("Order #${o["id"]}"),
                        subtitle: Text("Total: \$${o["totalAmount"]}"),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
