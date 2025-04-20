// transaction_history.dart
import 'package:expense_tracker/controller/history_controller.dart';
import 'package:expense_tracker/model/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionsListScreen extends StatelessWidget {
  final List<Transaction> transactions;

  TransactionsListScreen({super.key, required this.transactions}) {
    // Initialize controller with provided transactions
    Get.put(TransactionHistoryController(initialTransactions: transactions));
  }

  @override
  Widget build(BuildContext context) {
    // Get controller instance
    final controller = Get.find<TransactionHistoryController>();
    
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Transactions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // Additional actions could be added here
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (value) {
              // Handle filter selection
              if (value == 'all') {
                // No filtering needed, already shows all
              } else if (value == 'expenses') {
                // You could implement a filtered view here
              } else if (value == 'income') {
                // You could implement a filtered view here
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Transactions'),
              ),
              const PopupMenuItem(
                value: 'expenses',
                child: Text('Expenses Only'),
              ),
              const PopupMenuItem(
                value: 'income',
                child: Text('Income Only'),
              ),
            ],
          )
        ],
      ),
      body: Obx(() {
        if (controller.transactions.isEmpty) {
          return const Center(
            child: Text(
              'No transactions yet!',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.transactions.length,
          itemBuilder: (context, index) {
            final transaction = controller.transactions[index];
            return TransactionCard(
              transaction: transaction,
              onTap: () => controller.viewTransactionReceipt(transaction),
            );
          },
        );
      }),
      // You could add a FAB here to add new transactions
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigate to add transaction screen or show a dialog
          // This would be implemented in your app
        },
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM dd');
    final formattedDate = formatter.format(transaction.date);
    final color = transaction.isExpense ? Colors.red : Colors.green;
    final sign = transaction.isExpense ? '-' : '+';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF252836),
      child: Dismissible(
        key: Key(transaction.id),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          // Delete the transaction
          Get.find<TransactionHistoryController>().deleteTransaction(transaction.id);
          // Show a snackbar for feedback
          Get.snackbar(
            'Transaction Deleted',
            'Transaction has been removed',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.7),
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            mainButton: TextButton(
              onPressed: () {
                // You could implement an undo function here
              },
              child: const Text(
                'UNDO',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          onTap: onTap,
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.isExpense ? Icons.arrow_downward : Icons.arrow_upward,
              color: color,
            ),
          ),
          title: Text(
            transaction.category,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            transaction.description,
            style: const TextStyle(color: Colors.white70),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$sign RS. ${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}