import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/food_item.dart';

class AddFoodScreen extends StatefulWidget {
  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _costController = TextEditingController();
  final DatabaseService dbService = DatabaseService();

  void _saveFoodItem() async {
    if (_formKey.currentState!.validate()) {
      final foodItem = FoodItem(name: _nameController.text, cost: double.parse(_costController.text));
      await dbService.insertFoodItem(foodItem);
      Navigator.pop(context); // Return to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Food Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Food Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _costController,
                decoration: InputDecoration(labelText: 'Cost'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter a cost' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveFoodItem,
                child: Text('Save Food Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
