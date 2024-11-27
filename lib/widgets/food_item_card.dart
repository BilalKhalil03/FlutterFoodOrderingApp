import 'package:flutter/material.dart';
import '../models/food_item.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final Function onDelete;
  final Function onUpdate;

  const FoodItemCard({required this.item, required this.onDelete, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        title: Text(item.name),
        subtitle: Text('\$${item.cost.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.edit), onPressed: () => onUpdate()),
            IconButton(icon: Icon(Icons.delete), onPressed: () => onDelete()),
          ],
        ),
      ),
    );
  }
}
