

// File: lib/repositories/savings_goal_repository.dart


import 'package:untitled1/data/database_helper.dart';
import 'package:untitled1/models/savings_goal.dart';

class SavingsGoalRepository {
  final dbHelper = DatabaseHelper();

  Future<int> createSavingsGoal(SavingsGoal goal) async {
    final db = await dbHelper.database;
    return await db.insert('savings_goals', goal.toMap());
  }

  Future<List<SavingsGoal>> getSavingsGoalsForUser(int userId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'savings_goals',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return SavingsGoal.fromMap(maps[i]);
    });
  }

  Future<int> updateSavingsGoal(SavingsGoal goal) async {
    final db = await dbHelper.database;
    return await db.update(
      'savings_goals',
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  Future<int> deleteSavingsGoal(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'savings_goals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}