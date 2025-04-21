import 'package:expense_tracker/screen/statement.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/model/model.dart';
import 'package:expense_tracker/screen/transaction_history.dart';

class DrawerController extends GetxController {
  final RxList<Transaction> transactions = <Transaction>[].obs;

  // Method to update transactions
  void setTransactions(List<Transaction> newTransactions) {
    transactions.assignAll(newTransactions);
  }

  // Drawer navigation methods
  void navigateToTransactionHistory(BuildContext context) {
    Get.back(); // Close drawer
    Get.to(() => TransactionsListScreen(transactions: transactions.toList()));
  }

  void navigateToStatement(BuildContext context) {
    Get.back();
    Get.to(() => StatementScreen(transactions: transactions.toList()));
  }

  void navigateToPremium(BuildContext context) {
    Get.back();
    // Get.to(() => PremiumScreen());
  }

  void navigateToRecords(BuildContext context) {
    Get.back();
    // Get.to(() => RecordsScreen());
  }

  void navigateToBankSync(BuildContext context) {
    Get.back();
    // Get.to(() => BankSyncScreen());
  }

  void navigateToImports(BuildContext context) {
    Get.back();
    // Get.to(() => ImportsScreen());
  }

  void navigateToTags(BuildContext context) {
    Get.back();
    // Get.to(() => TagsScreen());
  }

  void navigateToCards(BuildContext context) {
    Get.back();
    // Get.to(() => CardsScreen());
  }

  void navigateToBudget(BuildContext context) {
    Get.back();
    // Get.to(() => BudgetScreen());
  }

  void navigateToCVV(BuildContext context) {
    Get.back();
    // Get.to(() => CVVScreen());
  }

  void navigateToLists(BuildContext context) {
    Get.back();
    // Get.to(() => ListsScreen());
  }

  void navigateToSettings(BuildContext context) {
    Get.back();
    // Get.to(() => SettingsScreen());
  }
}
