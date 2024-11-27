class FoodItem {
  int? id;
  String name;
  double cost;

  FoodItem({
    this.id,
    required this.name,
    required this.cost,
  });

  // Convert FoodItem to a map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
    };
  }

  // Create a FoodItem from a map
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      cost: map['cost'],
    );
  }
}
