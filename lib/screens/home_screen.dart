import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/database_service.dart';
import 'add_food_screen.dart';
import 'manage_orders_screen.dart';
import '../models/order_plan.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService dbService = DatabaseService();
  late Future<List<FoodItem>> foodItemsFuture;

  final TextEditingController _targetCostController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  List<FoodItem> selectedFoodItems = [];

  @override
  void initState() {
    super.initState();
    foodItemsFuture = dbService.getFoodItems();
  }

  void _saveOrderPlan() async {
    if (_dateController.text.isEmpty || _targetCostController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final selectedDate = _dateController.text;
    final targetCost = double.parse(_targetCostController.text);

    final totalCost = selectedFoodItems.fold(0.0, (sum, item) => sum + item.cost);

    if (totalCost > targetCost) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Total cost exceeds the target cost')));
      return;
    }

    final foodIds = selectedFoodItems.map((item) => item.id).join(',');

    final orderPlan = OrderPlan(date: selectedDate, foodIds: foodIds, targetCost: targetCost);
    await dbService.insertOrderPlan(orderPlan);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order Plan Saved')));
    setState(() {
      selectedFoodItems = [];
      _targetCostController.clear();
      _dateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Ordering App'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFoodScreen()),
              ).then((_) => setState(() {
                foodItemsFuture = dbService.getFoodItems();
              }));
            },
          ),
          IconButton(
            icon: Icon(Icons.manage_search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageOrdersScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _targetCostController,
              decoration: InputDecoration(
                labelText: 'Target Cost Per Day',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<FoodItem>>(
              future: foodItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No food items found.'));
                } else {
                  final foodItems = snapshot.data!;
                  return ListView.builder(
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      final foodItem = foodItems[index];
                      final isSelected = selectedFoodItems.contains(foodItem);
                      return ListTile(
                        title: Text(foodItem.name),
                        subtitle: Text('\$${foodItem.cost.toStringAsFixed(2)}'),
                        trailing: Icon(
                          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                          color: isSelected ? Colors.green : null,
                        ),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedFoodItems.remove(foodItem);
                            } else {
                              selectedFoodItems.add(foodItem);
                            }
                          });
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _saveOrderPlan,
              child: Text('Save Order Plan'),
            ),
          ),
        ],
      ),
    );
  }
}
