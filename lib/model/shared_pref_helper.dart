import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/model/model.dart';

class SharedPrefsHelper {
  // Keys
  static const String transactionKey = 'transactions';
  static const String budgetKey = 'budgets';

  // Transaction methods
  static Future<List<Transaction>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getStringList(transactionKey) ?? [];
    
    return transactionsJson.map((json) {
      final map = jsonDecode(json);
      return Transaction.fromJson(map);
    }).toList();
  }

  static Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    
    final transactionsJson = transactions.map((tx) {
      return jsonEncode(tx.toJson());
    }).toList();
    
    await prefs.setStringList(transactionKey, transactionsJson);
  }

  // Budget methods
  static Future<List<Budget>> loadBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final budgetsJson = prefs.getStringList(budgetKey) ?? [];
    
    return budgetsJson.map((json) {
      final map = jsonDecode(json);
      return Budget.fromJson(map);
    }).toList();
  }

  static Future<void> saveBudgets(List<Budget> budgets) async {
    final prefs = await SharedPreferences.getInstance();
    
    final budgetsJson = budgets.map((budget) {
      return jsonEncode(budget.toJson());
    }).toList();
    
    await prefs.setStringList(budgetKey, budgetsJson);
  }
}