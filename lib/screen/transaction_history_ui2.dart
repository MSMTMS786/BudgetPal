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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.black87),
            onPressed: () {
              // Show filter options
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => FilterBottomSheet(
                  onFilterSelected: (value) {
                    controller.filterTransactions(value);
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined, color: Colors.black87),
            onPressed: () {
              // Show date range picker
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Date range indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'This Month',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '${DateFormat('MMM dd').format(DateTime.now().subtract(const Duration(days: 30)))} - ${DateFormat('MMM dd').format(DateTime.now())}',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('All', true, () => controller.filterTransactions('all')),
                _buildFilterChip('Debits', false, () => controller.filterTransactions('expenses')),
                _buildFilterChip('Credits', false, () => controller.filterTransactions('income')),
                _buildFilterChip('Food', false, () {}),
                _buildFilterChip('Shopping', false, () {}),
                _buildFilterChip('Transfer', false, () {}),
                _buildFilterChip('Bills', false, () {}),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Transactions list
          Expanded(
            child: Obx(() {
              if (controller.filteredTransactions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 56,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No transactions found',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your filters',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              // Group transactions by date
              final groupedTransactions = _groupTransactionsByDate(controller.filteredTransactions);
              
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: groupedTransactions.length,
                itemBuilder: (context, index) {
                  final dateKey = groupedTransactions.keys.elementAt(index);
                  final transactionsForDate = groupedTransactions[dateKey]!;
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        color: Colors.grey[50],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDateHeader(dateKey),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            // Optional: Add total for the day
                            Text(
                              _calculateDailyTotal(transactionsForDate),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Transactions for this date
                      ...transactionsForDate.map((transaction) => BankTransactionItem(
                        transaction: transaction,
                        onTap: () => controller.viewTransactionReceipt(transaction),
                      )),
                      
                      const Divider(height: 1),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0047CC) : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
  
  // Helper method to group transactions by date
  Map<DateTime, List<Transaction>> _groupTransactionsByDate(List<Transaction> transactions) {
    final groupedTransactions = <DateTime, List<Transaction>>{};
    
    for (final transaction in transactions) {
      // Remove time part to group by date
      final dateOnly = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      
      if (!groupedTransactions.containsKey(dateOnly)) {
        groupedTransactions[dateOnly] = [];
      }
      
      groupedTransactions[dateOnly]!.add(transaction);
    }
    
    // Sort dates in descending order (most recent first)
    final sortedKeys = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    
    return {
      for (var key in sortedKeys) key: groupedTransactions[key]!,
    };
  }
  
  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
      return 'Today';
    } else if (dateOnly.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    } else {
      return DateFormat('EEEE, MMMM d').format(date);
    }
  }
  
  String _calculateDailyTotal(List<Transaction> transactions) {
    double total = 0;
    for (final transaction in transactions) {
      if (transaction.isExpense) {
        total -= transaction.amount;
      } else {
        total += transaction.amount;
      }
    }
    
    return total >= 0
        ? '+Rs. ${total.toStringAsFixed(2)}'
        : '-Rs. ${total.abs().toStringAsFixed(2)}';
  }
}

class BankTransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const BankTransactionItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormatter = DateFormat('HH:mm');
    final formattedTime = timeFormatter.format(transaction.date);
    
    // Get merchant logo or category icon
    Widget leadingWidget = _getMerchantLogo(transaction);
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Merchant logo/icon
            SizedBox(
              width: 40,
              height: 40,
              child: leadingWidget,
            ),
            const SizedBox(width: 12),
            
            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getMerchantName(transaction),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        transaction.category,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatAmount(transaction),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: transaction.isExpense ? Colors.red[700] : Colors.green[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.paymentMethod,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _getMerchantLogo(Transaction transaction) {
    Color backgroundColor;
    IconData iconData;
    String initial = transaction.description.isNotEmpty ? transaction.description[0].toUpperCase() : 'T';
    
    if (transaction.isExpense) {
      switch (transaction.category.toLowerCase()) {
        case 'food':
          iconData = Icons.restaurant;
          backgroundColor = Colors.orange[100]!;
          break;
        case 'shopping':
          iconData = Icons.shopping_bag;
          backgroundColor = Colors.purple[100]!;
          break;
        case 'transport':
        case 'transportation':
          iconData = Icons.directions_car;
          backgroundColor = Colors.blue[100]!;
          break;
        case 'bills':
        case 'utilities':
          iconData = Icons.receipt;
          backgroundColor = Colors.red[100]!;
          break;
        case 'health':
        case 'healthcare':
          iconData = Icons.medical_services;
          backgroundColor = Colors.green[100]!;
          break;
        default:
          // Generic merchant icon with initial
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          );
      }
    } else {
      switch (transaction.category.toLowerCase()) {
        case 'salary':
          iconData = Icons.work;
          backgroundColor = Colors.green[100]!;
          break;
        case 'gift':
          iconData = Icons.card_giftcard;
          backgroundColor = Colors.purple[100]!;
          break;
        case 'investment':
          iconData = Icons.trending_up;
          backgroundColor = Colors.blue[100]!;
          break;
        default:
          iconData = Icons.account_balance;
          backgroundColor = Colors.green[100]!;
      }
    }
    
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(
        iconData,
        color: Colors.black87,
        size: 20,
      ),
    );
  }
  
  String _getMerchantName(Transaction transaction) {
    // In a real banking app, you would have a proper merchant name
    // For now, we'll use the description or create one from the category
    if (transaction.description.isNotEmpty) {
      return transaction.description.split(' ').first;
    }
    
    switch (transaction.category.toLowerCase()) {
      case 'food':
        return 'Restaurant Payment';
      case 'shopping':
        return 'Retail Purchase';
      case 'transport':
        return 'Transportation';
      case 'bills':
        return 'Utility Bill';
      case 'salary':
        return 'Salary Deposit';
      default:
        return transaction.category;
    }
  }
  
  String _formatAmount(Transaction transaction) {
    if (transaction.isExpense) {
      return '-Rs. ${transaction.amount.toStringAsFixed(2)}';
    } else {
      return '+Rs. ${transaction.amount.toStringAsFixed(2)}';
    }
  }
}

class FilterBottomSheet extends StatelessWidget {
  final Function(String) onFilterSelected;
  
  const FilterBottomSheet({
    super.key,
    required this.onFilterSelected,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Filter Transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          _buildFilterOption('All Transactions', Icons.receipt_long, () {
            onFilterSelected('all');
          }),
          _buildFilterOption('Debits Only', Icons.arrow_downward, () {
            onFilterSelected('expenses');
          }),
          _buildFilterOption('Credits Only', Icons.arrow_upward, () {
            onFilterSelected('income');
          }),
          const Divider(),
          _buildFilterOption('This Month', Icons.calendar_today, () {
            // Apply this month filter
          }),
          _buildFilterOption('Last Month', Icons.calendar_month, () {
            // Apply last month filter
          }),
          _buildFilterOption('Custom Range', Icons.date_range, () {
            // Show date range picker
          }),
        ],
      ),
    );
  }
  
  Widget _buildFilterOption(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[700]),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}