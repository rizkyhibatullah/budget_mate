import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../db/db_helper.dart';

class TransactionProvider extends ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  Future<void> loadTransactions(int userId) async {
    _transactions = await _dbHelper.getTransactionsByUser(userId);
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _dbHelper.insertTransaction(transaction);
    await loadTransactions(transaction.userId);
  }

  Future<void> deleteTransaction(int id, int userId) async {
    await _dbHelper.deleteTransaction(id);
    await loadTransactions(userId);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _dbHelper.updateTransaction(transaction);
    await loadTransactions(transaction.userId);
  }
}
