import 'package:expense_tracker/controller/add_transaction_controller.dart';
import 'package:expense_tracker/model/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTransactionScreen extends StatelessWidget {
  final Transaction? transaction;
  
  const AddTransactionScreen({Key? key, this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddTransactionController(editTransaction: transaction));

    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
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
                  child: Obx(() => GestureDetector(
                    onTap: () => controller.isIncome.value = true,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: controller.isIncome.value ? Colors.green : Colors.transparent,
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
                  )),
                ),
                Expanded(
                  child: Obx(() => GestureDetector(
                    onTap: () => controller.isIncome.value = false,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !controller.isIncome.value ? Colors.red : Colors.transparent,
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
                  )),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => DropdownButton<String>(
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
                  value: controller.selectedPaymentMethod.value,
                  onChanged: (value) => controller.selectedPaymentMethod.value = value,
                  items: const [
                    DropdownMenuItem(value: "Cash", child: Text("Cash")),
                    DropdownMenuItem(value: "Card", child: Text("Card")),
                    DropdownMenuItem(
                      value: "Transfer",
                      child: Text("Online Transfer"),
                    ),
                  ],
                )),
                Obx(() => controller.isIncome.value 
                  ? Container() 
                  : DropdownButton<String>(
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
                    value: controller.selectedCategory.value,
                    onChanged: (value) => controller.selectedCategory.value = value,
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
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Obx(() => Text(
            "RS. ${controller.amount.value}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          )),

          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: controller.descriptionController,
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
                if (controller.isValid()) {
                  final transaction = controller.createTransaction();
                  Get.back(result: transaction);
                } else {
                  Get.snackbar(
                    'Invalid Input',
                    'Please enter a valid amount and description.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: Text(
                transaction == null ? "Tap to ADD" : " UPDATE ",
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
              childAspectRatio: 1.5,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                ...List.generate(
                  9,
                  (i) => _buildNumberButton((i + 1).toString(), controller),
                ),
                _buildNumberButton(".", controller),
                _buildNumberButton("0", controller),
                _buildDeleteButton(controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String digit, AddTransactionController controller) {
    return GestureDetector(
      onTap: () => controller.updateAmount(digit),
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

  Widget _buildDeleteButton(AddTransactionController controller) {
    return InkWell(
      onTap: () => controller.deleteDigit(),
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