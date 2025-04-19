import 'package:expense_tracker/model/model.dart';
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? transaction;
  const AddTransactionScreen({super.key, this.transaction});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String amount = "0";
  String? selectedCategory;
  String? selectedPaymentMethod;
  bool isIncome = true;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    _descriptionController = TextEditingController(
        text: t != null ? t.description : "");
    if (t != null) {
      amount = t.amount.toStringAsFixed(0);
      selectedCategory = t.category;
      selectedPaymentMethod = t.paymentMethod;
      isIncome = !t.isExpense;
    }
  }

  void updateAmount(String value) {
    setState(() {
      if (amount == "0" && value != ".") {
        amount = value;
      } else {
        if (value == "." && amount.contains(".")) return;
        amount += value;
      }
    });
  }

  void _deleteDigit() {
    setState(() {
      amount = amount.length > 1 ? amount.substring(0, amount.length - 1) : "0";
    });
  }

  void _addTransaction() {
    final transaction = Transaction(
      id: widget.transaction?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      amount: double.tryParse(amount) ?? 0.0,
      isExpense: !isIncome,
      category: selectedCategory ?? (isIncome ? "Income" : "Expense"),
      description: _descriptionController.text.isEmpty
          ? "No description"
          : _descriptionController.text,
      date: DateTime.now(),
      paymentMethod: selectedPaymentMethod ?? "Cash",
    );
    Navigator.pop(context, transaction);
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
      ),
      body: Column(
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
                        color: isIncome ? Colors.green : Colors.transparent,
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
                        color: !isIncome ? Colors.red : Colors.transparent,
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

          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  dropdownColor: const Color(0xFF1F1D2B),
                  underline: Container(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white70,
                  ),
                  style: const TextStyle(color: Colors.white),
                  hint: const Text(
                    "Payment Method",
                    style: TextStyle(color: Colors.white70),
                  ),
                  value: selectedPaymentMethod,
                  onChanged: (value) =>
                      setState(() => selectedPaymentMethod = value),
                  items: const [
                    DropdownMenuItem(value: "Cash", child: Text("Cash")),
                    DropdownMenuItem(value: "Card", child: Text("Card")),
                    DropdownMenuItem(
                      value: "Transfer",
                      child: Text("Online Transfer"),
                    ),
                  ],
                ),
                if (!isIncome)
                  DropdownButton<String>(
                    dropdownColor: const Color(0xFF1F1D2B),
                    underline: Container(),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white70,
                    ),
                    style: const TextStyle(color: Colors.white),
                    hint: const Text(
                      "Category",
                      style: TextStyle(color: Colors.white70),
                    ),
                    value: selectedCategory,
                    onChanged: (value) =>
                        setState(() => selectedCategory = value),
                    items: const [
                      DropdownMenuItem(value: "Food", child: Text("Food")),
                      DropdownMenuItem(
                        value: "Transport",
                        child: Text("Transport"),
                      ),
                      DropdownMenuItem(
                        value: "Shopping",
                        child: Text("Shopping"),
                      ),
                      DropdownMenuItem(
                        value: "Entertainment",
                        child: Text("Entertainment"),
                      ),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "RS. $amount",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: "Add Description",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: const BoxDecoration(color: Color(0xFF1F1D2B)),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F1D2B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (amount != "0" &&
                    _descriptionController.text.trim().isNotEmpty) {
                  _addTransaction();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Please enter a valid amount and description."),
                    ),
                  );
                }
              },
              child: Text(
                widget.transaction == null ? "Tap to ADD" : " UPDATE ",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Flexible(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 10,
              childAspectRatio: 2,
              children: [
                ...List.generate(
                  9,
                  (i) => _buildNumberButton((i + 1).toString()),
                ),
                _buildNumberButton("."),
                _buildNumberButton("0"),
                _buildDeleteButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String digit) {
    return GestureDetector(
      onTap: () => updateAmount(digit),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.3),
        ),
        child: Text(
          digit,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
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
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: const Icon(
          Icons.backspace_outlined,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
