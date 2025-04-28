import 'package:expense_tracker/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/model/model.dart';
import 'package:expense_tracker/model/shared_pref_helper.dart';
import 'package:uuid/uuid.dart';

class BudgetController extends GetxController {
  final RxList<Budget> budgets = <Budget>[].obs;
  final RxBool isLoading = true.obs;
  final Uuid _uuid = Uuid();

  @override
  void onInit() {
    super.onInit();
    loadBudgets();
    
    // Listen for transaction changes
    final txController = Get.find<TransactionController>();
    ever(txController.transactions, (_) => updateSpentAmounts());
  }

  Future<void> loadBudgets() async {
    isLoading.value = true;
    try {
      List<Budget> loadedBudgets = await SharedPrefsHelper.loadBudgets();
      budgets.value = loadedBudgets;
      updateSpentAmounts();
    } catch (e) {
      print('Error loading budgets: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSpentAmounts() {
    final txController = Get.find<TransactionController>();
    
    // Reset all spent amounts
    for (var budget in budgets) {
      budget.spent = 0.0;
    }
    
    // Calculate spent amounts from transactions
    for (var transaction in txController.transactions) {
      if (transaction.isExpense) {
        // Find matching budget by category
        for (var budget in budgets) {
          if (budget.category.toLowerCase() == transaction.category.toLowerCase()) {
            budget.spent += transaction.amount;
            break;
          }
        }
      }
    }
    
    // Force UI update
    budgets.refresh();
    
    // Save updated budgets
    saveBudgets();
  }

  void addBudget(String category, double amount, Color color) {
    // Check if budget for this category already exists
    bool exists = budgets.any((b) => b.category.toLowerCase() == category.toLowerCase());
    
    if (exists) {
      Get.snackbar(
        'Category Exists',
        'A budget for this category already exists',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    Budget newBudget = Budget(
      id: _uuid.v4(),
      category: category,
      amount: amount,
      spent: 0.0,
      colorValue: color.value,
    );
    
    budgets.add(newBudget);
    updateSpentAmounts();
    saveBudgets();
  }

  void updateBudget(String id, double amount) {
    int index = budgets.indexWhere((b) => b.id == id);
    if (index != -1) {
      Budget updated = Budget(
        id: budgets[index].id,
        category: budgets[index].category,
        amount: amount,
        spent: budgets[index].spent,
        colorValue: budgets[index].colorValue,
      );
      
      budgets[index] = updated;
      saveBudgets();
    }
  }

  void deleteBudget(String id) {
    budgets.removeWhere((b) => b.id == id);
    saveBudgets();
  }

  Future<void> saveBudgets() async {
    try {
      await SharedPrefsHelper.saveBudgets(budgets.toList());
    } catch (e) {
      print('Error saving budgets: $e');
    }
  }
}