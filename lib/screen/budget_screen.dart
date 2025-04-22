// set_budget_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SetBudgetScreen extends StatefulWidget {
  const SetBudgetScreen({Key? key}) : super(key: key);

  @override
  State<SetBudgetScreen> createState() => _SetBudgetScreenState();
}

class _SetBudgetScreenState extends State<SetBudgetScreen> {
  final List<Map<String, dynamic>> _budgets = [
    {
      'category': 'Food',
      'amount': 500.0,
      'spent': 320.0,
      'color': Colors.green,
    },
    {
      'category': 'Transportation',
      'amount': 300.0,
      'spent': 180.0,
      'color': Colors.blue,
    },
    {
      'category': 'Entertainment',
      'amount': 200.0,
      'spent': 150.0,
      'color': Colors.purple,
    },
    {
      'category': 'Shopping',
      'amount': 400.0,
      'spent': 380.0,
      'color': Colors.orange,
    },
    {
      'category': 'Bills',
      'amount': 800.0,
      'spent': 750.0,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Management'),
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: _budgets.map((budget) {
                  final double percentage = budget['spent'] / budget['amount'];
                  return PieChartSectionData(
                    color: budget['color'],
                    value: budget['amount'],
                    title: budget['category'],
                    radius: 100,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _budgets.length,
              itemBuilder: (context, index) {
                final budget = _budgets[index];
                final double percentage = budget['spent'] / budget['amount'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: budget['color'],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                budget['category'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\$${budget['spent'].toStringAsFixed(2)} / \$${budget['amount'].toStringAsFixed(2)}',
                            style: TextStyle(
                              color: percentage > 0.9 ? Colors.red : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          percentage > 0.9 ? Colors.red : budget['color'],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Remaining: \$${(budget['amount'] - budget['spent']).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: percentage > 0.9 ? Colors.red : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                _showAddBudgetDialog();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Set New Budget'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBudgetDialog() {
    String category = '';
    double amount = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set New Budget'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                category = value;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                amount = double.tryParse(value) ?? 0;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (category.isNotEmpty && amount > 0) {
                setState(() {
                  _budgets.add({
                    'category': category,
                    'amount': amount,
                    'spent': 0.0,
                    'color': Colors.primaries[_budgets.length % Colors.primaries.length],
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

