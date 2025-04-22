// lists_screen.dart
import 'package:flutter/material.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({Key? key}) : super(key: key);

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  final List<Map<String, dynamic>> _transactionLists = [
    {
      'name': 'Monthly Bills',
      'count': 8,
      'total': 1250.0,
      'icon': Icons.receipt,
      'color': Colors.blue,
    },
    {
      'name': 'Subscriptions',
      'count': 5,
      'total': 85.0,
      'icon': Icons.subscriptions,
      'color': Colors.purple,
    },
    {
      'name': 'Grocery Shopping',
      'count': 12,
      'total': 420.0,
      'icon': Icons.shopping_basket,
      'color': Colors.green,
    },
    {
      'name': 'Dining Out',
      'count': 7,
      'total': 310.0,
      'icon': Icons.restaurant,
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Lists'),
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _transactionLists.length,
              itemBuilder: (context, index) {
                final list = _transactionLists[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    onTap: () {
                      // Navigate to list details
                    },
                    leading: CircleAvatar(
                      backgroundColor: list['color'],
                      child: Icon(
                        list['icon'],
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      list['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${list['count']} transactions',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Text(
                      '\$${list['total'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                _showCreateListDialog();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Create New List'),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateListDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New List'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'List Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _transactionLists.add({
                    'name': nameController.text,
                    'count': 0,
                    'total': 0.0,
                    'icon': Icons.list,
                    'color': Colors.primaries[_transactionLists.length % Colors.primaries.length],
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
