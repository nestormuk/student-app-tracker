class BudgetLimit {
  int? id;
  int? categoryId; // null means overall budget
  double amount;
  int month;
  int year;
  int userId;

  BudgetLimit({
    this.id,
    this.categoryId,
    required this.amount,
    required this.month,
    required this.year,
    required this.userId,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'amount': amount,
      'month': month,
      'year': year,
      'user_id': userId,
    };
  }

  factory BudgetLimit.fromMap(Map<String, dynamic> map) {
    return BudgetLimit(
      id: map['id'],
      categoryId: map['category_id'],
      amount: map['amount'],
      month: map['month'],
      year: map['year'],
      userId: map['user_id'],
    );
  }
}