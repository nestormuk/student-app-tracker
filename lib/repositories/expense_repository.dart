



import 'package:untitled1/data/database_helper.dart';
import 'package:untitled1/models/expense.dart';

class ExpenseRepository {
  final dbHelper = DatabaseHelper();

  /// Create a new expense
  Future<int> createExpense(Expense expense) async {
    final db = await dbHelper.database;
    return await db.insert('expenses', expense.toMap());
  }

  /// Fetch all expenses for a specific user
  Future<List<Expense>> getExpensesForUser(int userId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  /// Fetch all expenses for a specific category
  Future<List<Expense>> getExpensesForCategory(int categoryId, int userId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'category_id = ? AND user_id = ?',
      whereArgs: [categoryId, userId],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  /// Update an expense
  Future<int> updateExpense(Expense expense) async {
    final db = await dbHelper.database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<List<Expense>> getExpensesByCategory(int categoryId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  /// Delete an expense
  Future<int> deleteExpense(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get total expense amount for a user
  Future<double> getTotalExpensesForUser(int userId) async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses WHERE user_id = ?',
      [userId],
    );

    return result.first['total'] != null ? (result.first['total'] as num).toDouble() : 0.0;
  }
}
