class SavingsGoal {
  int? id;
  String name;
  double targetAmount;
  double currentAmount;
  DateTime? targetDate;
  int userId;

  SavingsGoal({
    this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.targetDate,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
      'target_date': targetDate?.toIso8601String(),
      'user_id': userId,
    };
  }

  factory SavingsGoal.fromMap(Map<String, dynamic> map) {
    return SavingsGoal(
      id: map['id'],
      name: map['name'],
      targetAmount: map['target_amount'],
      currentAmount: map['current_amount'],
      targetDate: map['target_date'] != null
          ? DateTime.parse(map['target_date'])
          : null,
      userId: map['user_id'],
    );
  }
}
