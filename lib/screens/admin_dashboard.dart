import 'package:flutter/material.dart';
import '../models/admin_stats.dart';
import '../services/admin_stats_service.dart';

class AdminDashboard extends StatefulWidget {

  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>{

  AdminStats? stats;
  bool loading=true;

  void loadStats() async{

    stats=await AdminStatsService.getStats();

    setState(() {
      loading=false;
    });

  }

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            Row(

              children: [

                Expanded(
                  child: statCard(
                      "Revenue",
                      "\$${stats!.totalRevenue}",
                      Icons.attach_money
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: statCard(
                      "Orders",
                      stats!.orderCount.toString(),
                      Icons.shopping_cart
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(

              children: [

                Expanded(
                  child: statCard(
                      "Customers",
                      stats!.userCount.toString(),
                      Icons.people
                  ),
                ),

              ],
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Orders",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(

              child: ListView.builder(

                itemCount: stats!.recentOrders.length,

                itemBuilder:(context,index){

                  final order=stats!.recentOrders[index];

                  return Card(

                    child: ListTile(

                      title: Text("Order #${order["id"]}"),

                      subtitle: Text(
                          "Total: \$${order["totalAmount"]}"
                      ),

                      trailing: Text(order["status"]),

                    ),
                  );
                },
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget statCard(String title,String value,IconData icon){

    return Card(

      child: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            Icon(icon,size:30),

            const SizedBox(height:10),

            Text(
              value,
              style: const TextStyle(
                  fontSize:22,
                  fontWeight: FontWeight.bold
              ),
            ),

            Text(title)

          ],
        ),
      ),
    );
  }
}