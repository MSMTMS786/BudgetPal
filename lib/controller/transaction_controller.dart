import 'package:get/get.dart';
import 'package:expense_tracker/model/model.dart';
import 'package:expense_tracker/model/shared_pref_helper.dart';

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
  }

  void updateTransaction(String id, Transaction updatedTransaction) {
    final index = transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      transactions[index] = updatedTransaction;
      calculateBalances();
      saveTransactions();
    }
  }

  Future<void> deleteTransaction(int index) async {
    transactions.removeAt(index);
    calculateBalances();
    saveTransactions();
  }

  void saveTransactions() {
    SharedPrefsHelper.saveTransactions(transactions.toList());
  }
}