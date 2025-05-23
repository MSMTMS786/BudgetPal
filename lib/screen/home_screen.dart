import 'package:expense_tracker/model/model.dart';
import 'package:expense_tracker/screen/add_expense_income.dart';
import 'package:expense_tracker/widgets/Drawer.dart';
import 'package:expense_tracker/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final TransactionController transactionController = Get.put(TransactionController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> _confirmDelete(BuildContext context, Transaction transaction) async {
    bool confirm = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete the ${transaction.isExpense ? "expense" : "income"} of RS ${transaction.amount.toStringAsFixed(2)} for ${transaction.category}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                confirm = false;
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                confirm = true;
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    return confirm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Obx(() => MyDrawer(transactions: transactionController.transactions)),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F0D49),
        title: const Text('BudgetPal', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3F0D49), Color(0xFF1A1A2E)],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (transactionController.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFFFFD700)));
            }
            
            return Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      const Text('Available Balance', style: TextStyle(color: Color(0xFFFFD700), fontSize: 14)),
                      const SizedBox(height: 8),
                      Obx(() => Text(
                        "RS ${transactionController.balance.value.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Obx(() => _buildGraph("Expenses", transactionController.expensePercentage, Colors.red)),
                      const SizedBox(height: 10),
                      Obx(() => _buildGraph("Income", transactionController.incomePercentage, Colors.green)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('My Transactions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                      FloatingActionButton(
                        onPressed: () async {
                          final result = await Get.to(() => const AddTransactionScreen());
                          if (result != null) {
                            transactionController.addTransaction(result);
                          }
                        },
                        backgroundColor: const Color(0xFFFFD700),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Obx(() {
                    if (transactionController.transactions.isEmpty) {
                      return const Center(
                        child: Text('No transactions yet', style: TextStyle(color: Colors.white)),
                      );
                    }
                    
                    return ListView.builder(
                      itemCount: transactionController.transactions.length,
                      itemBuilder: (context, index) {
                        final reversedIndex = transactionController.transactions.length - 1 - index;
                        final transaction = transactionController.transactions[reversedIndex];

                        return Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20.0),
                            color: Colors.blue,
                            child: const Icon(Icons.edit, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            color: Colors.red,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              final editedTransaction = await Get.to(
                                () => AddTransactionScreen(transaction: transaction)
                              );

                              if (editedTransaction != null) {
                                transactionController.updateTransaction(transaction.id, editedTransaction);
                              }

                              return false; // Don't dismiss the tile
                            } else if (direction == DismissDirection.endToStart) {
                              return await _confirmDelete(context, transaction);
                            }
                            return false;
                          },
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              transactionController.deleteTransaction(reversedIndex);
                              Get.snackbar(
                                'Transaction Deleted', 
                                '${transaction.category} transaction deleted',
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2)
                              );
                            }
                          },
                          child: _buildTransactionItem(transaction),
                        );
                      },
                    );
                  }),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildGraph(String label, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: percentage.clamp(0.0, 1.0),
          backgroundColor: Colors.white.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 10,
        ),
        const SizedBox(height: 5),
        Text("${(percentage * 100).toStringAsFixed(1)}%", style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(transaction.category),
          child: Text(
            _getCategoryInitial(transaction.category),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(transaction.category),
        subtitle: Text("${transaction.description} • ${DateFormat.yMMMd().format(transaction.date)}"),
        trailing: Text(
          '${transaction.isExpense ? '-' : '+'} RS.${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(color: transaction.isExpense ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _getCategoryInitial(String category) {
    if (category.isEmpty) return "?";
    return category[0].toUpperCase();
  }

  Color _getCategoryColor(String category) {
    if (category.isEmpty) return Colors.grey.withOpacity(0.2);
    final int hashCode = category.toLowerCase().hashCode;
    final colors = [
      Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple,
      Colors.teal, Colors.pink, Colors.indigo, Colors.amber, Colors.cyan,
      Colors.deepOrange, Colors.lightBlue,
    ];
    return colors[hashCode.abs() % colors.length];
  }
}