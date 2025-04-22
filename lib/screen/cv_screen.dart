// cvv_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CVVScreen extends StatefulWidget {
  const CVVScreen({Key? key}) : super(key: key);

  @override
  State<CVVScreen> createState() => _CVVScreenState();
}

class _CVVScreenState extends State<CVVScreen> {
  final List<Map<String, dynamic>> _cards = [
    {
      'cardNumber': '•••• •••• •••• 4242',
      'cardHolder': 'John Doe',
      'expiryDate': '12/25',
      'cvv': '123',
      'cardType': 'Visa',
      'isVisible': false,
    },
    {
      'cardNumber': '•••• •••• •••• 5555',
      'cardHolder': 'John Doe',
      'expiryDate': '07/27',
      'cvv': '456',
      'cardType': 'Mastercard',
      'isVisible': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CVV Management'),
        backgroundColor: Colors.blue[900],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        card['cardType'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        card['cardNumber'],
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Card Holder: ${card['cardHolder']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Expiry Date: ${card['expiryDate']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'CVV: ',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            card['isVisible'] ? card['cvv'] : '•••',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              card['isVisible'] ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                card['isVisible'] = !card['isVisible'];
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: card['cvv']));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('CVV copied to clipboard'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
