

// File: lib/repositories/savings_goal_repository.dart


import 'package:untitled1/data/database_helper.dart';
import 'package:untitled1/models/savings_goal.dart';

class SavingsGoalRepository {
  final dbHelper = DatabaseHelper();

  Future<int> createSavingsGoal(SavingsGoal goal) async {
    final db = await dbHelper.database;
    return await db.insert('savings_goals', goal.toMap());
  }

  Future<double> getSavingsProgressForUser(int userId) async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
        'SELECT SUM(saved_amount) as total_saved, SUM(target_amount) as total_target FROM savings_goals WHERE user_id = ?',
        [userId]
    );

    if (result.isNotEmpty && result.first['total_saved'] != null && result.first['total_target'] != null) {
      double totalSaved = (result.first['total_saved'] as num).toDouble();
      double totalTarget = (result.first['total_target'] as num).toDouble();

      if (totalTarget == 0) return 0.0; // Avoid division by zero
      return (totalSaved / totalTarget) * 100; // Return progress as a percentage
    }
    return 0.0;
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