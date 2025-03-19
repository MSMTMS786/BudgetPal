import 'package:expense_tracker/screen/transaction_history.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/model/model.dart';
// Import your transactions list screen


class MyDrawer extends StatefulWidget {
  final List<Transaction> transactions;
  
  const MyDrawer({Key? key, required this.transactions}) : super(key: key);
  
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF121329), // Dark background color
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    // Dark blue at top
                    Color(0xffE84040),
                    Color(0xFF1A1A2E), 
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                'Rehman',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                'BudgetPal Owner',
                style: TextStyle(color: Colors.grey),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/MyPic.jpeg',
                ), // Change as needed
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    Icons.workspace_premium,
                    'Get Premium',
                    context,
                    () {
                      Navigator.pop(context);
                      // Navigate to Premium screen
                    },
                  ),
                  _buildDrawerItem(
                    Icons.insert_chart, 
                    'Records', 
                    context,
                    () {
                      Navigator.pop(context);
                      // Navigate to Records screen
                    },
                  ),
                  _buildDrawerItem(
                    Icons.account_balance, 
                    'Bank Sync', 
                    context,
                    () {
                      Navigator.pop(context);
                      // Navigate to Bank Sync screen
                    },
                  ),
                  _buildDrawerItem(
                    Icons.upload_file, 
                    'Imports', 
                    context,
                    () {
                      Navigator.pop(context);
                      // Navigate to Imports screen
                    },
                  ),
                  _buildDrawerItem(
                    Icons.receipt, 
                    'Receipts', 
                    context,
                    () {
                      Navigator.pop(context);
                      // Navigate to Transactions List Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionsListScreen(
                            transactions: widget.transactions,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    Icons.label, 
                    'Tags', 
                    context,
                    () {
                      Navigator.pop(context);
                      // Navigate to Tags screen
                    },
                  ),
                  _buildDrawerItem(
                    Icons.credit_card, 
                    'Cards', 
                    context,
                    () {
                      Navigator.pop(context);
                      // Navigate to Cards screen
                    },
                  ),
                  _buildDrawerItem(
                    Icons.account_balance_wallet,
                    'Set Budget',
                    context,
                    () {
                      Navigator.pop(context);
                      // Navigate to Budget screen
                    },
                  ),
                  _buildDrawerItem(
                    Icons.lock, 
                    'CVV', 
                    context,
                    () {
                      Navigator.pop(context);
                      // Navigate to CVV screen
                    },
                  ),
                  _buildDrawerItem(
                    Icons.list, 
                    'Lists', 
                    context,
                    () {
                      Navigator.pop(context);
                      // Navigate to Lists screen
                    },
                  ),
                  _buildDrawerItem(
                    Icons.settings, 
                    'Setting', 
                    context,
                    () {
                      Navigator.pop(context);
                      // Navigate to Settings screen
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
      onTap: onTap,
    );
  }
}