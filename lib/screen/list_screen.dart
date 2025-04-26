import 'package:expense_tracker/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/model/model.dart';

class ListsScreen extends StatelessWidget {
  final TransactionController transactionController = Get.find();

  ListsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Transactions',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        final List<Transaction> transactions = transactionController.transactions;

        final Map<String, Map<String, dynamic>> categorizedData = {};
        double totalIncome = 0.0;
        double totalExpense = 0.0;

        for (var tx in transactions) {
          if (!categorizedData.containsKey(tx.category)) {
            categorizedData[tx.category] = {
              'count': 0,
              'total': 0.0,
              'icon': _getCategoryIcon(tx.category),
              'color': _getCategoryColor(tx.category),
            };
          }

          categorizedData[tx.category]!['count'] += 1;
          categorizedData[tx.category]!['total'] += tx.amount;

          if (tx.isExpense) {
            totalExpense += tx.amount;
          } else {
            totalIncome += tx.amount;
          }
        }

        return Column(
          children: [
            // Simple Income/Expense summary
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard('Income', totalIncome, Colors.green),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryCard('Expense', totalExpense, Colors.red),
                  ),
                ],
              ),
            ),
            
            // Categories heading
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
            
            // Divider
            Divider(color: Colors.grey[200]),
            
            // Categories list
            Expanded(
              child: categorizedData.isEmpty
                  ? Center(
                      child: Text(
                        'No transactions yet',
                        style: TextStyle(
                          color: Colors.grey[400],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: categorizedData.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Colors.grey[200],
                      ),
                      itemBuilder: (context, index) {
                        final category = categorizedData.keys.elementAt(index);
                        final data = categorizedData[category]!;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: data['color'].withOpacity(0.1),
                                child: Icon(
                                  data['icon'],
                                  color: data['color'],
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '${data['count']} transactions',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'RS ${data['total'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[400],
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'RS ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'monthly bills':
        return Icons.receipt_outlined;
      case 'subscriptions':
        return Icons.subscriptions_outlined;
      case 'grocery shopping':
        return Icons.shopping_basket_outlined;
      case 'dining out':
        return Icons.restaurant_outlined;
      case 'salary':
        return Icons.account_balance_wallet_outlined;
      case 'transport':
        return Icons.directions_car_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'monthly bills':
        return Colors.blue;
      case 'subscriptions':
        return Colors.purple;
      case 'grocery shopping':
        return Colors.green;
      case 'dining out':
        return Colors.orange;
      case 'salary':
        return Colors.teal;
      case 'transport':
        return Colors.amber;
      default:
        return Colors.blueGrey;
    }
  }
}