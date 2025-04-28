// budget_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/model/model.dart';
import 'package:expense_tracker/controller/budget_controller.dart';

class SetBudgetScreen extends StatefulWidget {
  const SetBudgetScreen({Key? key}) : super(key: key);

  @override
  State<SetBudgetScreen> createState() => _SetBudgetScreenState();
}

class _SetBudgetScreenState extends State<SetBudgetScreen> {
  final BudgetController _budgetController = Get.put(BudgetController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Set Your Budget',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue[900],
      ),
      body: Obx(() {
        if (_budgetController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (_budgetController.budgets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No budgets set yet',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _showAddBudgetDialog(),
                  child: const Text('Add Your First Budget'),
                ),
              ],
            ),
          );
        }
        
        return Column(
          children: [
            SizedBox(height: 50,),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: _budgetController.budgets.map((budget) {
                    return PieChartSectionData(
                      color: Color(budget.colorValue),
                      value: budget.amount,
                      title: budget.category,
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
            const SizedBox(height: 50),
            Expanded(
              child: ListView.builder(
                itemCount: _budgetController.budgets.length,
                itemBuilder: (context, index) {
                  final budget = _budgetController.budgets[index];
                  final double percentage = budget.percentage;
                  
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
                                    color: Color(budget.colorValue),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  budget.category,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '\$${budget.spent.toStringAsFixed(2)} / \$${budget.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: percentage > 0.9 ? Colors.red : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () => _showEditBudgetDialog(budget),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () => _showDeleteConfirmation(budget),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: percentage > 1.0 ? 1.0 : percentage,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            percentage > 0.9 ? Colors.red : Color(budget.colorValue),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Remaining: \$${budget.remaining.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: percentage > 0.9 ? Colors.red : Colors.black54,
                              ),
                            ),
                            Text(
                              '${(percentage * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: percentage > 0.9 ? Colors.red : Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (percentage > 1.0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Over budget by \$${(budget.spent - budget.amount).toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
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
        );
      }),
    );
  }

  void _showAddBudgetDialog() {
    String category = '';
    double amount = 0;
    Color selectedColor = Colors.blue;
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    // List of predefined colors for selection
    final List<Color> colorOptions = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Set New Budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
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
                controller: amountController,
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
              const SizedBox(height: 16),
              const Text('Select Color:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: colorOptions.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selectedColor == color
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
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
                  _budgetController.addBudget(category, amount, selectedColor);
                  Navigator.pop(context);
                } else {
                  Get.snackbar(
                    'Invalid Input',
                    'Please enter a valid category name and amount',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBudgetDialog(Budget budget) {
    final TextEditingController amountController = TextEditingController(text: budget.amount.toString());
    double newAmount = budget.amount;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${budget.category} Budget'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Category: ${budget.category}'),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                newAmount = double.tryParse(value) ?? budget.amount;
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
              if (newAmount > 0) {
                _budgetController.updateBudget(budget.id, newAmount);
                Navigator.pop(context);
              } else {
                Get.snackbar(
                  'Invalid Amount',
                  'Please enter a valid amount',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Budget budget) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${budget.category} Budget?'),
        content: const Text('Are you sure you want to delete this budget? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              _budgetController.deleteBudget(budget.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}