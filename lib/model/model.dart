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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'isExpense': isExpense,
      'category': category,
      'description': description,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'],
      isExpense: json['isExpense'],
      category: json['category'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      paymentMethod: json['paymentMethod'],
    );
  }
}

// Model class for Budget
class Budget {
  final String id;
  final String category;
  final double amount;
  double spent;
  final int colorValue;

  Budget({
    required this.id,
    required this.category,
    required this.amount,
    this.spent = 0.0,
    required this.colorValue,
  });

  double get percentage => spent / amount;
  double get remaining => amount - spent;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'spent': spent,
      'colorValue': colorValue,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      category: json['category'],
      amount: json['amount'],
      spent: json['spent'],
      colorValue: json['colorValue'],
    );
  }
}