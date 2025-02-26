

// File: lib/repositories/category_repository.dart



import 'package:untitled1/data/database_helper.dart';

import '../models/category.dart';

class CategoryRepository {
  final dbHelper = DatabaseHelper();

  Future<List<Category>> getCategoriesForUser(int userId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'user_id = ? OR user_id = 0',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<int> createCategory(Category category) async {
    final db = await dbHelper.database;
    return await db.insert('categories', category.toMap());
  }

  Future<int> updateCategory(Category category) async {
    final db = await dbHelper.database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}