// drawer_controller.dart
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
  
  // Navigation methods for each drawer item
  void navigateToTransactionHistory(BuildContext context) {
    Get.back(); // Close drawer
    Get.to(() => TransactionsListScreen(transactions: transactions.toList()));
  }
  
  void navigateToPremium(BuildContext context) {
    Get.back();
    // Navigate to Premium screen
    // Get.to(() => PremiumScreen());
  }
  
  void navigateToRecords(BuildContext context) {
    Get.back();
    // Navigate to Records screen
    // Get.to(() => RecordsScreen());
  }
  
  void navigateToBankSync(BuildContext context) {
    Get.back();
    // Navigate to Bank Sync screen
    // Get.to(() => BankSyncScreen());
  }
  
  void navigateToImports(BuildContext context) {
    Get.back();
    // Navigate to Imports screen
    // Get.to(() => ImportsScreen());
  }
  
  void navigateToTags(BuildContext context) {
    Get.back();
    // Navigate to Tags screen
    // Get.to(() => TagsScreen());
  }
  
  void navigateToCards(BuildContext context) {
    Get.back();
    // Navigate to Cards screen
    // Get.to(() => CardsScreen());
  }
  
  void navigateToBudget(BuildContext context) {
    Get.back();
    // Navigate to Budget screen
    // Get.to(() => BudgetScreen());
  }
  
  void navigateToCVV(BuildContext context) {
    Get.back();
    // Navigate to CVV screen
    // Get.to(() => CVVScreen());
  }
  
  void navigateToLists(BuildContext context) {
    Get.back();
    // Navigate to Lists screen
    // Get.to(() => ListsScreen());
  }
  
  void navigateToSettings(BuildContext context) {
    Get.back();
    // Navigate to Settings screen
    // Get.to(() => SettingsScreen());
  }
}