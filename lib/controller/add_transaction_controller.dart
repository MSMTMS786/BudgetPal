import 'package:get/get.dart';
import 'package:expense_tracker/model/model.dart';
import 'package:flutter/material.dart';

class AddTransactionController extends GetxController {
  final TextEditingController descriptionController = TextEditingController();
  final RxString amount = "0".obs;
  final Rxn<String> selectedCategory = Rxn<String>();
  final Rxn<String> selectedPaymentMethod = Rxn<String>();
  final RxBool isIncome = true.obs;
  final Transaction? editTransaction;

  AddTransactionController({this.editTransaction});

  @override
  void onInit() {
    super.onInit();
    
    if (editTransaction != null) {
      descriptionController.text = editTransaction!.description;
      amount.value = editTransaction!.amount.toStringAsFixed(0);
      selectedCategory.value = editTransaction!.category;
      selectedPaymentMethod.value = editTransaction!.paymentMethod;
      isIncome.value = !editTransaction!.isExpense;
    }
  }

  void updateAmount(String value) {
    if (amount.value == "0" && value != ".") {
      amount.value = value;
    } else {
      if (value == "." && amount.value.contains(".")) return;
      amount.value += value;
    }
  }

  void deleteDigit() {
    amount.value = amount.value.length > 1 
        ? amount.value.substring(0, amount.value.length - 1) 
        : "0";
  }

  Transaction createTransaction() {
    return Transaction(
      id: editTransaction?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      amount: double.tryParse(amount.value) ?? 0.0,
      isExpense: !isIncome.value,
      category: selectedCategory.value ?? (isIncome.value ? "Income" : "Expense"),
      description: descriptionController.text.isEmpty
          ? "No description"
          : descriptionController.text,
      date: DateTime.now(),
      paymentMethod: selectedPaymentMethod.value ?? "Cash",
    );
  }

  bool isValid() {
    return amount.value != "0" && descriptionController.text.trim().isNotEmpty;
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}