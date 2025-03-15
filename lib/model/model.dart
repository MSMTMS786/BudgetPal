// Model class for Transaction
class Transaction {
  final String id;
  final double amount;
  final bool isExpense;
  late final String category;
  final String description;
  final DateTime date;
  final String paymentMethod;

  Transaction({
    required this.id,
    required this.amount,
    required this.isExpense,
    required this.category,
    required this.description,
    required this.date,
    required this.paymentMethod,
  });
}