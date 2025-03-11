import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
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
                  ),
                  _buildDrawerItem(Icons.insert_chart, 'Records', context),
                  _buildDrawerItem(Icons.account_balance, 'Bank Sync', context),
                  _buildDrawerItem(Icons.upload_file, 'Imports', context),
                  _buildDrawerItem(Icons.receipt, 'Receipts', context),
                  _buildDrawerItem(Icons.label, 'Tags', context),
                  _buildDrawerItem(Icons.credit_card, 'Cards', context),
                  _buildDrawerItem(
                    Icons.account_balance_wallet,
                    'Set Budget',
                    context,
                  ),
                  _buildDrawerItem(Icons.lock, 'CVV', context),
                  _buildDrawerItem(Icons.list, 'Lists', context),
                  _buildDrawerItem(Icons.settings, 'Setting', context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.amber),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
