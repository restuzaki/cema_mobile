class ProjectModel {
  final String id;
  final String name;
  final String phase;
  final String client;
  final String status; // 'berisiko', 'darurat', 'normal'
  final double cpi;
  final double spi;

  ProjectModel({
    required this.id,
    required this.name,
    required this.phase,
    required this.client,
    required this.status,
    required this.cpi,
    required this.spi,
  });

  ProjectModel copyWith({
    String? id,
    String? name,
    String? phase,
    String? client,
    String? status,
    double? cpi,
    double? spi,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phase: phase ?? this.phase,
      client: client ?? this.client,
      status: status ?? this.status,
      cpi: cpi ?? this.cpi,
      spi: spi ?? this.spi,
    );
  }
}

class TaskModel {
  final String id;
  final String projectId;
  final String title;
  final String responsibleName;
  final String description;
  final DateTime startDate;
  final DateTime dueDate;
  final String phase;
  final String status; // 'ongoing', 'late', 'done', 'menunggu'

  TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.responsibleName,
    required this.description,
    required this.startDate,
    required this.dueDate,
    required this.phase,
    required this.status,
  });

  TaskModel copyWith({
    String? id,
    String? projectId,
    String? title,
    String? responsibleName,
    String? description,
    DateTime? startDate,
    DateTime? dueDate,
    String? phase,
    String? status,
  }) {
    return TaskModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      responsibleName: responsibleName ?? this.responsibleName,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      dueDate: dueDate ?? this.dueDate,
      phase: phase ?? this.phase,
      status: status ?? this.status,
    );
  }
}

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
