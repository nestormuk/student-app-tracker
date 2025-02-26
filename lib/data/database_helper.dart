// File: lib/data/database_helper.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'expense_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    // Categories table
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color INTEGER NOT NULL,
        icon INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Expenses table
    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id),
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Budget Limits table
    await db.execute('''
      CREATE TABLE budget_limits(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        amount REAL NOT NULL,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id),
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Savings Goals table
    await db.execute('''
      CREATE TABLE savings_goals(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        target_amount REAL NOT NULL,
        current_amount REAL NOT NULL,
        target_date TEXT,
        user_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Insert default categories
    await db.rawInsert(
        "INSERT INTO categories (name, color, icon, user_id) VALUES ('Food', 4294198070, 58784, 0)");
    await db.rawInsert(
        "INSERT INTO categories (name, color, icon, user_id) VALUES ('Transport', 4293467747, 58515, 0)");
    await db.rawInsert(
        "INSERT INTO categories (name, color, icon, user_id) VALUES ('Entertainment', 4292886779, 58534, 0)");
    await db.rawInsert(
        "INSERT INTO categories (name, color, icon, user_id) VALUES ('Shopping', 4293128957, 58717, 0)");
    await db.rawInsert(
        "INSERT INTO categories (name, color, icon, user_id) VALUES ('Utilities', 4294940672, 58796, 0)");
  }
}