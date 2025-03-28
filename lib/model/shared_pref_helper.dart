import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/model.dart'; // Ensure correct path

class SharedPrefsHelper {
  static const String _transactionsKey = 'transactions';

  // Save Transactions
  static Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> encodedTransactions = transactions.map((t) => jsonEncode({
          'id': t.id,
          'amount': t.amount,
          'isExpense': t.isExpense,
          'category': t.category,
          'description': t.description,
          'date': t.date.toIso8601String(),
          'paymentMethod': t.paymentMethod,
        })).toList();
    await prefs.setStringList(_transactionsKey, encodedTransactions);
  }

  // Load Transactions
  static Future<List<Transaction>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? storedTransactions = prefs.getStringList(_transactionsKey);

    if (storedTransactions == null) return [];

    return storedTransactions.map((t) {
      final decoded = jsonDecode(t);
      return Transaction(
        id: decoded['id'],
        amount: decoded['amount'],
        isExpense: decoded['isExpense'],
        category: decoded['category'],
        description: decoded['description'],
        date: DateTime.parse(decoded['date']),
        paymentMethod: decoded['paymentMethod'],
      );
    }).toList();
  }

  // Clear Transactions
  static Future<void> clearTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_transactionsKey);
  }
}
