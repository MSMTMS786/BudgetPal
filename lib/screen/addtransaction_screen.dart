import 'package:flutter/material.dart';

class TransactionEntryScreen extends StatefulWidget {
  const TransactionEntryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionEntryScreen> createState() => _TransactionEntryScreenState();
}

class _TransactionEntryScreenState extends State<TransactionEntryScreen> {
  String _selectedTab = 'INCOME';
  String _amount = '0';
  // ignore: unused_field
  String _description = '';

  void _appendDigit(String digit) {
    setState(() {
      if (_amount == '0' && digit != '.') {
        _amount = digit;
      } else {
        _amount += digit;
      }
    });
  }

  void _backspace() {
    setState(() {
      if (_amount.length > 1) {
        _amount = _amount.substring(0, _amount.length - 1);
      } else {
        _amount = '0';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              icon: const Icon(Icons.arrow_drop_down, color: Colors.amber),
              underline: Container(),
              dropdownColor: const Color(0xFF252537),
              style: const TextStyle(color: Colors.amber),
              value: 'Cash',
              items:
                  ['Cash', 'Card', 'UPI', 'Bank']
                      .map(
                        (e) =>
                            DropdownMenuItem<String>(value: e, child: Text(e)),
                      )
                      .toList(),
              onChanged: (value) {},
              hint: const Text(
                'Payment Method',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab selector
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 'INCOME'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        color:
                            _selectedTab == 'INCOME'
                                ? const Color(0xFFE94560)
                                : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'INCOME',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 'EXPENSE'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        color:
                            _selectedTab == 'EXPENSE'
                                ? const Color(0xFFF9A826)
                                : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'EXPENSE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category dropdown
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF9A826).withOpacity(0.3),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Category', style: TextStyle(color: Colors.white)),
                SizedBox(width: 4.0),
                Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),

          // Amount display
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'RS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  _amount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Description input
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.edit, color: Colors.grey, size: 18.0),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Add Description',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => _description = value,
                  ),
                ),
              ],
            ),
          ),

          // Insert Template button
          Container(
            margin: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9A826),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Insert Template',style: TextStyle(color: Colors.white,fontSize: 18),),
            ),
          ),

          // Number pad
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16.0),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              crossAxisCount: 3,
              childAspectRatio: 4,
              children: [
                _buildNumberKey('1'),

                _buildNumberKey('2'),
                _buildNumberKey('3'),
                _buildNumberKey('4'),
                _buildNumberKey('5'),
                _buildNumberKey('6'),
                _buildNumberKey('7'),
                _buildNumberKey('8'),
                _buildNumberKey('9'),
                _buildNumberKey('.'),
                _buildNumberKey('0'),
                _buildBackspaceKey(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberKey(String digit) {
    return Material(
      borderRadius: BorderRadius.circular(20.0),
      color: const Color(0xFF252537),
      elevation: 4.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () => _appendDigit(digit),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            digit,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey() {
    return InkWell(
      onTap: _backspace,
      child: Container(
        alignment: Alignment.center,
        child: const Icon(
          Icons.backspace_outlined,
          color: Colors.white,
          size: 24.0,
        ),
      ),
    );
  }
}
