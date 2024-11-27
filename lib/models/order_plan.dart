class OrderPlan {
  int? id;
  String date;
  String foodIds; // Comma-separated list of food IDs
  double targetCost;

  OrderPlan({
    this.id,
    required this.date,
    required this.foodIds,
    required this.targetCost,
  });

  // Convert OrderPlan to a map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'food_ids': foodIds,
      'target_cost': targetCost,
    };
  }

  // Create an OrderPlan from a map
  factory OrderPlan.fromMap(Map<String, dynamic> map) {
    return OrderPlan(
      id: map['id'],
      date: map['date'],
      foodIds: map['food_ids'],
      targetCost: map['target_cost'],
    );
  }
}
