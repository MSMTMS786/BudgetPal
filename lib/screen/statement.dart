import 'package:expense_tracker/model/model.dart';
import 'package:expense_tracker/widgets/statement_genrator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatementScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const StatementScreen({Key? key, required this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy • hh:mm a');

    double totalIncome = transactions
        .where((tx) => !tx.isExpense)
        .fold(0.0, (sum, tx) => sum + tx.amount);
    double totalExpense = transactions
        .where((tx) => tx.isExpense)
        .fold(0.0, (sum, tx) => sum + tx.amount);
    double balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Statement',style: TextStyle(color:Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.teal.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share PDF',
            onPressed: () async {
              await StatementGenerator.shareStatement(transactions);
            },
            // color: Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download PDF',
            onPressed: () async {
              await StatementGenerator.generateAndShareStatement(transactions);
            },
            //  color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            color: Colors.teal.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _balanceCard('Balance', balance, Colors.teal),
                _balanceCard('Expenses', totalExpense, Colors.redAccent),
              ],
            ),
          ),
          const Divider(height: 0),

          // Transactions
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: Text('No transactions available.'))
                : ListView.builder(
                  
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: tx.isExpense ? Colors.redAccent : Colors.green,
                              child: Icon(
                                tx.isExpense ? Icons.arrow_upward : Icons.arrow_downward,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              tx.category,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tx.description,
                                maxLines: 2,),
                                const SizedBox(height: 4),
                                Text(
                                  dateFormat.format(tx.date),
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            trailing: Text(
                              (tx.isExpense ? '- ' : '+ ') +
                                  'Rs${tx.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: tx.isExpense ? Colors.red : Colors.green,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _balanceCard(String title, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
        const SizedBox(height: 4),
        Text(
          'Rs${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
