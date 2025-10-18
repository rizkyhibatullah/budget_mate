import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../db/db_helper.dart';

class GoalProvider extends ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();
  List<Goal> _goals = [];

  List<Goal> get goals => _goals;

  Future<void> loadGoals(int userId) async {
    _goals = await _dbHelper.getGoalsByUser(userId);
    notifyListeners();
  }

  Future<void> addGoal(Goal goal, int userId) async {
    await _dbHelper.insertGoal(goal);
    await loadGoals(userId);
  }


  Future<void> deleteGoal(int id, int userId) async {
    await _dbHelper.deleteGoal(id);
    await loadGoals(userId);
  }

  Future<void> updateGoal(Goal goal, int userId) async {
    await _dbHelper.updateGoal(goal);
    await loadGoals(userId);
  }

}
