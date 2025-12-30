class Task {
  String? sId;
  String? id;
  String? projectId;
  List<String>? assignedTo;
  String? createdBy;
  String? title;
  String? description;
  num? budgetAllocation;
  DateTime? dueDate;
  String? status; // TODO, IN_PROGRESS, IN_REVIEW, DONE
  List<Attachment>? attachments;
  bool? isPunchItem;
  Approval? approval;
  DateTime? createdAt;
  DateTime? updatedAt;

  Task({
    this.sId,
    this.id,
    this.projectId,
    this.assignedTo,
    this.createdBy,
    this.title,
    this.description,
    this.budgetAllocation,
    this.dueDate,
    this.status,
    this.attachments,
    this.isPunchItem,
    this.approval,
    this.createdAt,
    this.updatedAt,
  });

  Task.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    projectId = json['project_id'];
    if (json['assigned_to'] != null) {
      assignedTo = List<String>.from(json['assigned_to']);
    }
    createdBy = json['created_by'];
    title = json['title'];
    description = json['description'];
    budgetAllocation = json['budget_allocation'];
    dueDate = json['due_date'] != null
        ? DateTime.tryParse(json['due_date'])
        : null;
    status = json['status'];
    if (json['attachments'] != null) {
      attachments = <Attachment>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachment.fromJson(v));
      });
    }
    isPunchItem = json['is_punch_item'];
    approval = json['approval'] != null
        ? Approval.fromJson(json['approval'])
        : null;
    createdAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'])
        : null;
    updatedAt = json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['id'] = id;
    data['project_id'] = projectId;
    data['assigned_to'] = assignedTo;
    data['created_by'] = createdBy;
    data['title'] = title;
    data['description'] = description;
    data['budget_allocation'] = budgetAllocation;
    data['due_date'] = dueDate?.toIso8601String();
    data['status'] = status;
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    data['is_punch_item'] = isPunchItem;
    if (approval != null) {
      data['approval'] = approval!.toJson();
    }
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    return data;
  }
}

class Attachment {
  String? type; // FILE, IMAGE, LINK
  String? url;
  String? name;
  DateTime? uploadedAt;

  Attachment({this.type, this.url, this.name, this.uploadedAt});

  Attachment.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
    name = json['name'];
    uploadedAt = json['uploaded_at'] != null
        ? DateTime.tryParse(json['uploaded_at'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['url'] = url;
    data['name'] = name;
    data['uploaded_at'] = uploadedAt?.toIso8601String();
    return data;
  }
}

class Approval {
  bool? isApproved;
  String? approvedBy;
  String? rejectionNote;
  DateTime? approvedAt;

  Approval({
    this.isApproved,
    this.approvedBy,
    this.rejectionNote,
    this.approvedAt,
  });

  Approval.fromJson(Map<String, dynamic> json) {
    isApproved = json['is_approved'];
    approvedBy = json['approved_by'];
    rejectionNote = json['rejection_note'];
    approvedAt = json['approved_at'] != null
        ? DateTime.tryParse(json['approved_at'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_approved'] = isApproved;
    data['approved_by'] = approvedBy;
    data['rejection_note'] = rejectionNote;
    data['approved_at'] = approvedAt?.toIso8601String();
    return data;
  }
}
