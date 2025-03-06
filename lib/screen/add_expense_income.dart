import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isIncome = true;
  String amount = "0";
  String description = "";
  String? selectedCategory;

  void _addDigit(String digit) {
    setState(() {
      if (amount == "0" && digit != ".") {
        amount = digit;
      } else {
        // Prevent multiple decimal points
        if (digit == "." && amount.contains(".")) {
          return;
        }
        amount += digit;
      }
    });
  }

  void _deleteDigit() {
    setState(() {
      if (amount.length > 1) {
        amount = amount.substring(0, amount.length - 1);
      } else {
        amount = "0";
      }
    });
  }

  void _saveAmountAndContinue() {
    // Navigate to the edit screen and pass necessary data
    Navigator.pushReplacementNamed(
      context,
      '/editTransaction',
      arguments: {
        'isExpense': !isIncome,
        'amount': amount,
        // Add other data as needed
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              dropdownColor: const Color(0xFF1F1D2B),
              underline: Container(),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.amber),
              style: const TextStyle(color: Colors.amber),
              hint: const Text("Payment Method", style: TextStyle(color: Colors.amber)),
              onChanged: (value) {},
              items: const [
                DropdownMenuItem(value: "cash", child: Text("Cash")),
                DropdownMenuItem(value: "card", child: Text("Card")),
                DropdownMenuItem(value: "upi", child: Text("UPI")),
                DropdownMenuItem(value: "bank", child: Text("Bank Transfer")),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Income/Expense Toggle
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade900,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isIncome = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isIncome ? Colors.red : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "INCOME",
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
                        onTap: () => setState(() => isIncome = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isIncome ? Colors.orange : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "EXPENSE",
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

              // Category Dropdown
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1F1D2B),
                  underline: Container(),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                  style: const TextStyle(color: Colors.white),
                  hint: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Category",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  value: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  items: const [
                    DropdownMenuItem(value: "food", child: Text("Food")),
                    DropdownMenuItem(value: "transport", child: Text("Transport")),
                    DropdownMenuItem(value: "shopping", child: Text("Shopping")),
                    DropdownMenuItem(value: "entertainment", child: Text("Entertainment")),
                  ],
                ),
              ),

              // Amount Display
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "₹",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      amount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Description Input
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Add Description",
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),
              ),

              // Insert Template Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Insert Template",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              // Number Pad
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                    children: [
                      _buildNumberButton("1"),
                      _buildNumberButton("2"),
                      _buildNumberButton("3"),
                      _buildNumberButton("4"),
                      _buildNumberButton("5"),
                      _buildNumberButton("6"),
                      _buildNumberButton("7"),
                      _buildNumberButton("8"),
                      _buildNumberButton("9"),
                      _buildNumberButton("."),
                      _buildNumberButton("0"),
                      _buildDeleteButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Add save button
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _saveAmountAndContinue,
              backgroundColor: Colors.amber,
              child: const Icon(Icons.check),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String digit) {
    return InkWell(
      onTap: () => _addDigit(digit),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          digit,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return InkWell(
      onTap: _deleteDigit,
      child: Container(
        alignment: Alignment.center,
        child: const Icon(
          Icons.backspace_outlined,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}