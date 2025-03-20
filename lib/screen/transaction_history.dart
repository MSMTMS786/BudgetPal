import 'package:expense_tracker/model/model.dart';
import 'package:expense_tracker/screen/add_expense_income.dart';
import 'package:expense_tracker/screen/reciept_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsListScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionsListScreen({Key? key, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Text(
                'No transactions yet!',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return TransactionCard(
                  transaction: transaction,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceiptScreen(transaction: transaction),
                      ),
                    );
                  },
                );
              },
            ),
      
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionCard({
    Key? key,
    required this.transaction,
    required this.onTap,
  }) : super(key: key);

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
    );
  }
}