import 'package:expense_tracker/model/model.dart';
import 'package:expense_tracker/screen/add_expense_income.dart';
import 'package:expense_tracker/widgets/Drawer.dart';
import 'package:expense_tracker/model/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double balance = 0.0;
  double totalExpenses = 0.0;
  double totalIncome = 0.0;
  List<Transaction> transactions = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() async {
    List<Transaction> loadedTransactions = await SharedPrefsHelper.loadTransactions();
    setState(() {
      transactions = loadedTransactions;
      balance = transactions.fold(0.0, (sum, item) => sum + (item.isExpense ? -item.amount : item.amount));
      totalExpenses = transactions.where((t) => t.isExpense).fold(0.0, (sum, t) => sum + t.amount);
      totalIncome = transactions.where((t) => !t.isExpense).fold(0.0, (sum, t) => sum + t.amount);
    });
  }

  void updateBalance(Transaction transaction) {
    setState(() {
      if (transaction.isExpense) {
        totalExpenses += transaction.amount;
        balance -= transaction.amount;
      } else {
        totalIncome += transaction.amount;
        balance += transaction.amount;
      }
      transactions.add(transaction);
      SharedPrefsHelper.saveTransactions(transactions); // Save transactions persistently
    });
  }

  double get expensePercentage => balance == 0.0 ? 0.0 : (totalExpenses / (totalExpenses + totalIncome));
  double get incomePercentage => balance == 0.0 ? 0.0 : (totalIncome / (totalExpenses + totalIncome));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(transactions: transactions),
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
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    const Text('Available Balance', style: TextStyle(color: Color(0xFFFFD700), fontSize: 14)),
                    const SizedBox(height: 8),
                    Text("RS ${balance.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildGraph("Expenses", expensePercentage, Colors.red),
                    const SizedBox(height: 10),
                    _buildGraph("Income", incomePercentage, Colors.green),
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
                        final result = await Navigator.push<Transaction>(
                          context,
                          MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
                        );
                        if (result != null) {
                          updateBalance(result);
                        }
                      },
                      backgroundColor: Color(0xFFFFD700),
                      child: const Icon(Icons.add,color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: transactions.isEmpty
                    ? const Center(
                        child: Text('No transactions yet', style: TextStyle(color: Colors.white)),
                      )
                    : ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[transactions.length - 1 - index];
                          return _buildTransactionItem(transaction);
                        },
                      ),
              ),
            ],
          ),
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
          backgroundColor: transaction.isExpense ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
          child: Icon(transaction.isExpense ? Icons.remove : Icons.add, color: transaction.isExpense ? Colors.orange : Colors.green),
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
}
