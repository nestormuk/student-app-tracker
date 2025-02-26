class Category {
  int? id;
  String name;
  int color;
  int icon;
  int userId;

  Category({
    this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
      'user_id': userId,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      icon: map['icon'],
      userId: map['user_id'],
    );
  }
}