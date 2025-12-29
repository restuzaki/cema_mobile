class Expense {
  final String? id;
  final String projectId;
  final String title;
  final num amount;
  final String currency; // 'IDR', 'USD', 'SGD'
  final String category; // 'TRANSPORTATION', 'MATERIAL', 'MEAL', 'OTHER'
  final DateTime date;
  final String? receiptUrl;
  final String? status;
  final String? rejectionNote;
  final String? approvedBy;
  final DateTime? approvedAt;

  Expense({
    this.id,
    required this.projectId,
    required this.title,
    required this.amount,
    required this.currency,
    required this.category,
    required this.date,
    this.receiptUrl,
    this.status,
    this.rejectionNote,
    this.approvedBy,
    this.approvedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] ?? json['_id'],
      projectId: json['project_id'] is Map
          ? json['project_id']['id']
          : json['project_id'],
      title: json['title'],
      amount: json['amount'],
      currency: json['currency'] ?? 'IDR',
      category: json['category'],
      date: DateTime.parse(json['date']),
      receiptUrl: json['receipt_url'],
      status: json['status'],
      rejectionNote: json['rejection_note'],
      approvedBy: json['approved_by'] is Map
          ? json['approved_by']['id']
          : json['approved_by'],
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project_id': projectId,
      'title': title,
      'amount': amount,
      'currency': currency,
      'category': category,
      'date': date.toIso8601String(),
      if (receiptUrl != null) 'receipt_url': receiptUrl,
    };
  }
}
