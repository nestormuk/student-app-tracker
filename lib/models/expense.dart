class Expense {
  int? id;
  double amount;
  String name;
  DateTime date;
  int categoryId;
  int userId;

  Expense({
    this.id,
    required this.amount,
    required this.name,
    required this.date,
    required this.categoryId,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'name': name,
      'date': date.toIso8601String(),
      'category_id': categoryId,
      'user_id': userId,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      name: map['name'],
      date: DateTime.parse(map['date']),
      categoryId: map['category_id'],
      userId: map['user_id'],
    );
  }
}