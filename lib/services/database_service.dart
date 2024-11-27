import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food_item.dart';
import '../models/order_plan.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'food_ordering.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE food_items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            cost REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE order_plan (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            food_ids TEXT,
            target_cost REAL
          )
        ''');
      },
      version: 1,
    );
  }

  // CRUD operations for FoodItem and OrderPlan
  Future<void> insertFoodItem(FoodItem item) async {
    final db = await database;
    await db.insert('food_items', item.toMap());
  }

  Future<List<FoodItem>> getFoodItems() async {
    final db = await database;
    final maps = await db.query('food_items');
    return List.generate(maps.length, (i) => FoodItem.fromMap(maps[i]));
  }

  Future<void> insertOrderPlan(OrderPlan plan) async {
    final db = await database;
    await db.insert('order_plan', plan.toMap());
  }

  Future<List<OrderPlan>> getOrderPlansByDate(String date) async {
    final db = await database;
    final maps = await db.query(
      'order_plan',
      where: date.isNotEmpty ? 'date = ?' : null,
      whereArgs: date.isNotEmpty ? [date] : null,
    );
    return List.generate(maps.length, (i) => OrderPlan.fromMap(maps[i]));
  }
}
