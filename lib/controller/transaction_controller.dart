import 'package:get/get.dart';
import 'package:expense_tracker/model/model.dart';
import 'package:expense_tracker/model/shared_pref_helper.dart';
import 'package:expense_tracker/controller/budget_controller.dart';

class TransactionController extends GetxController {
  // Observable variables
  final RxList<Transaction> transactions = <Transaction>[].obs;
  final RxDouble balance = 0.0.obs;
  final RxDouble totalExpenses = 0.0.obs;
  final RxDouble totalIncome = 0.0.obs;
  final RxBool isLoading = true.obs;

  // Computed properties
  double get expensePercentage {
    final total = totalExpenses.value + totalIncome.value;
    return total <= 0 ? 0.0 : (totalExpenses.value / total);
  }

  double get incomePercentage {
    final total = totalExpenses.value + totalIncome.value;
    return total <= 0 ? 0.0 : (totalIncome.value / total);
  }

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    isLoading.value = true;
    List<Transaction> loadedTransactions = await SharedPrefsHelper.loadTransactions();
    
    transactions.value = loadedTransactions;
    calculateBalances();
    isLoading.value = false;
    
    // Update budget spent amounts if BudgetController exists
    if (Get.isRegistered<BudgetController>()) {
      Get.find<BudgetController>().updateSpentAmounts();
    }
  }

  void calculateBalances() {
    double balanceValue = 0.0;
    double expensesValue = 0.0;
    double incomeValue = 0.0;

    for (var transaction in transactions) {
      if (transaction.isExpense) {
        expensesValue += transaction.amount;
        balanceValue -= transaction.amount;
      } else {
        incomeValue += transaction.amount;
        balanceValue += transaction.amount;
      }
    }

    balance.value = balanceValue;
    totalExpenses.value = expensesValue;
    totalIncome.value = incomeValue;
  }

  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
    calculateBalances();
    saveTransactions();
    
    // Update budget spent amounts
    if (Get.isRegistered<BudgetController>()) {
      Get.find<BudgetController>().updateSpentAmounts();
    }
  }

  void updateTransaction(String id, Transaction updatedTransaction) {
    final index = transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      transactions[index] = updatedTransaction;
      calculateBalances();
      saveTransactions();
      
      // Update budget spent amounts
      if (Get.isRegistered<BudgetController>()) {
        Get.find<BudgetController>().updateSpentAmounts();
      }
    }
  }

  Future<void> deleteTransaction(int index) async {
    transactions.removeAt(index);
    calculateBalances();
    saveTransactions();
    
    // Update budget spent amounts
    if (Get.isRegistered<BudgetController>()) {
      Get.find<BudgetController>().updateSpentAmounts();
    }
  }

  // Get transactions by category
  List<Transaction> getTransactionsByCategory(String category) {
    return transactions.where((tx) => 
      tx.category.toLowerCase() == category.toLowerCase()
    ).toList();
  }

  void saveTransactions() {
    SharedPrefsHelper.saveTransactions(transactions.toList());
  }
}