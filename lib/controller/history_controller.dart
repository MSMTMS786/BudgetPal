// transaction_history_controller.dart
import 'package:get/get.dart';
import 'package:expense_tracker/model/model.dart';
import 'package:expense_tracker/screen/reciept_screen.dart';

class TransactionHistoryController extends GetxController {
  // Observable list of transactions
  final RxList<Transaction> transactions = <Transaction>[].obs;
  
  // Constructor to initialize transactions
  TransactionHistoryController({required List<Transaction> initialTransactions}) {
    transactions.assignAll(initialTransactions);
  }
  
  // Method to navigate to receipt screen
  void viewTransactionReceipt(Transaction transaction) {
    Get.to(() => ReceiptScreen(transaction: transaction));
  }
  
  // Method to add a new transaction
  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
    // Sort transactions by date (newest first)
    sortTransactions();
  }
  
  // Method to update a transaction
  void updateTransaction(Transaction updatedTransaction) {
    final index = transactions.indexWhere((t) => t.id == updatedTransaction.id);
    if (index != -1) {
      transactions[index] = updatedTransaction;
      // Sort after updating
      sortTransactions();
    }
  }
  
  // Method to delete a transaction
  void deleteTransaction(String transactionId) {
    transactions.removeWhere((t) => t.id == transactionId);
  }
  
  // Method to sort transactions by date (newest first)
  void sortTransactions() {
    transactions.sort((a, b) => b.date.compareTo(a.date));
  }
  
  // Filter transactions by type (expense/income)
  List<Transaction> getTransactionsByType(bool isExpense) {
    return transactions.where((t) => t.isExpense == isExpense).toList();
  }
  
  // Get total expense amount
  double get totalExpenses {
    return transactions
        .where((t) => t.isExpense)
        .fold(0, (sum, t) => sum + t.amount);
  }
  
  // Get total income amount
  double get totalIncome {
    return transactions
        .where((t) => !t.isExpense)
        .fold(0, (sum, t) => sum + t.amount);
  }
  
  // Get balance (income - expenses)
  double get balance {
    return totalIncome - totalExpenses;
  }
}