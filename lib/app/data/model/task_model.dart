class TaskModel {
  final String id;
  final String projectId;
  final String title;
  final String responsibleName;
  final String description;
  final DateTime dueDate;
  final String phase;
  final String status;

  TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.responsibleName,
    required this.description,
    required this.dueDate,
    required this.phase,
    required this.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      projectId: json['projectId'],
      title: json['title'],
      responsibleName: json['assignedTo'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : DateTime.now(),
      phase: json['priority'] ?? '',
      status: json['status'] ?? 'menunggu',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'title': title,
      'description': description,
      'assignedTo': responsibleName,
      'status': status,
      'priority': phase,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  TaskModel copyWith({
    String? id,
    String? projectId,
    String? title,
    String? responsibleName,
    String? description,
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
      dueDate: dueDate ?? this.dueDate,
      phase: phase ?? this.phase,
      status: status ?? this.status,
    );
  }
}
