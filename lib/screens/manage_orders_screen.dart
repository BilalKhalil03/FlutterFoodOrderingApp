import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/order_plan.dart';

class ManageOrdersScreen extends StatefulWidget {
  @override
  _ManageOrdersScreenState createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  final DatabaseService dbService = DatabaseService();
  late Future<List<OrderPlan>> orderPlansFuture;
  final TextEditingController _dateQueryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    orderPlansFuture = dbService.getOrderPlansByDate('');
  }

  void _queryOrders() {
    final date = _dateQueryController.text;
    setState(() {
      orderPlansFuture = dbService.getOrderPlansByDate(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _dateQueryController,
              decoration: InputDecoration(
                labelText: 'Enter Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _queryOrders,
            child: Text('Search Orders'),
          ),
          Expanded(
            child: FutureBuilder<List<OrderPlan>>(
              future: orderPlansFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No orders found.'));
                } else {
                  final orders = snapshot.data!;
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return ListTile(
                        title: Text(order.date),
                        subtitle: Text('Food IDs: ${order.foodIds} - \$${order.targetCost.toStringAsFixed(2)}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
