// Continuing from the budget_repository.dart file:



import 'package:untitled1/data/database_helper.dart';

import '../models/budget_limit.dart';

class BudgetRepository {
  final dbHelper = DatabaseHelper();

  Future<int> createOrUpdateBudget(BudgetLimit budget) async {
    final db = await dbHelper.database;

    // Check if budget already exists for this category/month/year
    final List<Map<String, dynamic>> existingBudgets = await db.query(
      'budget_limits',
      where: 'user_id = ? AND category_id ${budget.categoryId == null ? 'IS NULL' : '= ?'} AND month = ? AND year = ?',
      whereArgs: budget.categoryId == null
          ? [budget.userId, budget.month, budget.year]
          : [budget.userId, budget.categoryId, budget.month, budget.year],
    );

    if (existingBudgets.isNotEmpty) {
      // Update existing budget
      budget.id = existingBudgets.first['id'] as int;
      return await db.update(
        'budget_limits',
        budget.toMap(),
        where: 'id = ?',
        whereArgs: [budget.id],
      );
    } else {
      // Create new budget
      return await db.insert('budget_limits', budget.toMap());
    }
  }

  Future<BudgetLimit?> getBudget(int userId, int? categoryId, int month, int year) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> budgets = await db.query(
      'budget_limits',
      where: 'user_id = ? AND category_id ${categoryId == null ? 'IS NULL' : '= ?'} AND month = ? AND year = ?',
      whereArgs: categoryId == null
          ? [userId, month, year]
          : [userId, categoryId, month, year],
    );

    if (budgets.isNotEmpty) {
      return BudgetLimit.fromMap(budgets.first);
    }
    return null;
  }

  Future<List<BudgetLimit>> getAllBudgetsForPeriod(int userId, int month, int year) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'budget_limits',
      where: 'user_id = ? AND month = ? AND year = ?',
      whereArgs: [userId, month, year],
    );

    return List.generate(maps.length, (i) {
      return BudgetLimit.fromMap(maps[i]);
    });
  }

  Future<int> deleteBudget(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'budget_limits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}