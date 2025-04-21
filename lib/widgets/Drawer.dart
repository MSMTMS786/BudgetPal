// drawer.dart
import 'package:expense_tracker/controller/drawer_controller.dart' as drawer_controller;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/model/model.dart';


class MyDrawer extends StatelessWidget {
  final List<Transaction> transactions;
  
  MyDrawer({Key? key, required this.transactions}) : super(key: key) {
    // Initialize controller
    final controller = Get.put(drawer_controller.DrawerController());
    // Update transactions in controller
    controller.setTransactions(transactions);
  }
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<drawer_controller.DrawerController>();
    
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
                    () => controller.navigateToPremium(context),
                  ),
                  _buildDrawerItem(
                    Icons.insert_chart, 
                    'Records', 
                    context,
                    () => controller.navigateToRecords(context),
                  ),
                  _buildDrawerItem(
                    Icons.account_balance, 
                    'Bank Sync', 
                    context,
                    () => controller.navigateToBankSync(context),
                  ),
                  _buildDrawerItem(
                    Icons.upload_file, 
                    'Statement', 
                    context,
                    () => controller.navigateToStatement(context),
                  ),
                  _buildDrawerItem(
                    Icons.receipt, 
                    'Receipts', 
                    context,
                    () => controller.navigateToTransactionHistory(context),
                  ),
                  _buildDrawerItem(
                    Icons.label, 
                    'Tags', 
                    context,
                    () => controller.navigateToTags(context),
                  ),
                  _buildDrawerItem(
                    Icons.credit_card, 
                    'Cards', 
                    context,
                    () => controller.navigateToCards(context),
                  ),
                  _buildDrawerItem(
                    Icons.account_balance_wallet,
                    'Set Budget',
                    context,
                    () => controller.navigateToBudget(context),
                  ),
                  _buildDrawerItem(
                    Icons.lock, 
                    'CVV', 
                    context,
                    () => controller.navigateToCVV(context),
                  ),
                  _buildDrawerItem(
                    Icons.list, 
                    'Lists', 
                    context,
                    () => controller.navigateToLists(context),
                  ),
                  _buildDrawerItem(
                    Icons.settings, 
                    'Setting', 
                    context,
                    () => controller.navigateToSettings(context),
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