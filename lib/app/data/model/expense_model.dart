class ExpenseModel {
  final String id;
  final String projectId;
  final double amount;
  final String description;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime createdAt;

  ExpenseModel({
    required this.id,
    required this.projectId,
    required this.amount,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  ExpenseModel copyWith({
    String? id,
    String? projectId,
    double? amount,
    String? description,
    String? status,
    DateTime? createdAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
