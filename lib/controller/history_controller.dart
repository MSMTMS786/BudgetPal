import 'package:get/get.dart';
import 'package:expense_tracker/model/model.dart';
import 'package:expense_tracker/screen/reciept_screen.dart';

class TransactionHistoryController extends GetxController {
  // Observable list of all transactions
  final RxList<Transaction> transactions = <Transaction>[].obs;

  // Observable list for filtered transactions
  final RxList<Transaction> filteredTransactions = <Transaction>[].obs;

  // Constructor to initialize transactions
  TransactionHistoryController({required List<Transaction> initialTransactions}) {
    transactions.assignAll(initialTransactions);
    filteredTransactions.assignAll(initialTransactions); // Initially, show all transactions
  }

  // Method to navigate to the receipt screen
  void viewTransactionReceipt(Transaction transaction) {
    Get.to(() => ReceiptScreen(transaction: transaction));
  }

  // Method to add a new transaction
  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
    // Sort transactions by date (newest first)
    sortTransactions();
    filterTransactions('all'); // Reapply the current filter after adding a transaction
  }

  // Method to update a transaction
  void updateTransaction(Transaction updatedTransaction) {
    final index = transactions.indexWhere((t) => t.id == updatedTransaction.id);
    if (index != -1) {
      transactions[index] = updatedTransaction;
      // Sort after updating
      sortTransactions();
      filterTransactions('all'); // Reapply the current filter after updating a transaction
    }
  }

  // Method to delete a transaction
  void deleteTransaction(String transactionId) {
    transactions.removeWhere((t) => t.id == transactionId);
    filterTransactions('all'); // Reapply the current filter after deletion
  }

  // Method to sort transactions by date (newest first)
  void sortTransactions() {
    transactions.sort((a, b) => b.date.compareTo(a.date));
  }

  // Filter transactions based on type (all, expenses, income)
  void filterTransactions(String filter) {
    if (filter == 'all') {
      filteredTransactions.assignAll(transactions); // Show all transactions
    } else if (filter == 'expenses') {
      filteredTransactions.assignAll(
          transactions.where((t) => t.isExpense).toList()); // Show only expenses
    } else if (filter == 'income') {
      filteredTransactions.assignAll(
          transactions.where((t) => !t.isExpense).toList()); // Show only income
    }
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
