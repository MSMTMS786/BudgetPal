// tags_screen.dart
import 'package:flutter/material.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({Key? key}) : super(key: key);

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  final List<Map<String, dynamic>> _tags = [
    {'name': 'Food', 'color': Colors.green},
    {'name': 'Transportation', 'color': Colors.blue},
    {'name': 'Entertainment', 'color': Colors.purple},
    {'name': 'Shopping', 'color': Colors.orange},
    {'name': 'Bills', 'color': Colors.red},
  ];

  final TextEditingController _tagController = TextEditingController();
  final List<Color> _colorOptions = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.amber,
  ];
  Color _selectedColor = Colors.blue;

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  void _addNewTag() {
    if (_tagController.text.isEmpty) return;

    setState(() {
      _tags.add({
        'name': _tagController.text,
        'color': _selectedColor,
      });
      _tagController.clear();
      _selectedColor = Colors.blue;
    });
  }

  void _deleteTag(int index) {
    setState(() {
      _tags.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Tags'),
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: const InputDecoration(
                      labelText: 'New Tag',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Select Color'),
                        content: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _colorOptions.map((color) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = color;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addNewTag,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tags.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _tags[index]['color'],
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(_tags[index]['name']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTag(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
