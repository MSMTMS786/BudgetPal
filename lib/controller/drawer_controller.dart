import 'package:expense_tracker/screen/budget_screen.dart';
import 'package:expense_tracker/screen/cards_screen.dart';
import 'package:expense_tracker/screen/cv_screen.dart';
import 'package:expense_tracker/screen/list_screen.dart';
import 'package:expense_tracker/screen/settings.dart';
import 'package:expense_tracker/screen/statement.dart';
import 'package:expense_tracker/screen/tag_screen.dart';
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
    Get.snackbar(
      'Coming Soon',
      'Premium features will be available in the next update',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }

  void navigateToRecords(BuildContext context) {
    Get.back();
    // Get.to(() => RecordsScreen());
    Get.snackbar(
      'Coming Soon',
      'Records screen will be available in the next update',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }

  void navigateToBankSync(BuildContext context) {
    Get.back();
    // Get.to(() => BankSyncScreen());
    Get.snackbar(
      'Coming Soon',
      'Bank sync feature will be available in the next update',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }

  void navigateToImports(BuildContext context) {
    Get.back();
    // Get.to(() => ImportsScreen());
    Get.snackbar(
      'Coming Soon',
      'Import feature will be available in the next update',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );
  }

  void navigateToTags(BuildContext context) {
    Get.back();
    Get.to(() => TagsScreen());
  }

  void navigateToCards(BuildContext context) {
    Get.back();
    Get.to(() => CardsScreen());
  }

  void navigateToBudget(BuildContext context) {
    Get.back();
    Get.to(() => SetBudgetScreen());
  }

  void navigateToCVV(BuildContext context) {
    Get.back();
    Get.to(() => CVVScreen());
  }

  void navigateToLists(BuildContext context) {
    Get.back();
    Get.to(() => ListsScreen());
  }

  void navigateToSettings(BuildContext context) {
    Get.back();
    Get.to(() => SettingsScreen());
  }
}