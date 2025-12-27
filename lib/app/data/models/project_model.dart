class Project {
  String? sId;
  String? id;
  String? name;
  String? description;
  String? status;
  Location? location;
  Financials? financials;
  List<String>? teamMembers;
  num? progress;
  String? clientName;
  String? managerName;
  String? serviceName;
  String? adminId;
  String? clientId;
  String? managerId;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  Project({
    this.sId,
    this.id,
    this.name,
    this.description,
    this.status,
    this.location,
    this.financials,
    this.teamMembers,
    this.progress,
    this.clientName,
    this.managerName,
    this.serviceName,
    this.adminId,
    this.clientId,
    this.managerId,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  Project.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    financials = json['financials'] != null
        ? Financials.fromJson(json['financials'])
        : null;
    if (json['team_members'] != null) {
      teamMembers = List<String>.from(json['team_members']);
    }
    progress = json['progress'];
    clientName = json['clientName'];
    managerName = json['managerName'];
    serviceName = json['serviceName'];
    adminId = json['admin_id'];
    clientId = json['client_id'];
    managerId = json['manager_id'];
    startDate = json['startDate'] != null
        ? DateTime.tryParse(json['startDate'])
        : null;
    endDate = json['endDate'] != null
        ? DateTime.tryParse(json['endDate'])
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
    data['name'] = name;
    data['description'] = description;
    data['status'] = status;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (financials != null) {
      data['financials'] = financials!.toJson();
    }
    data['team_members'] = teamMembers;
    data['progress'] = progress;
    data['clientName'] = clientName;
    data['managerName'] = managerName;
    data['serviceName'] = serviceName;
    data['admin_id'] = adminId;
    data['client_id'] = clientId;
    data['manager_id'] = managerId;
    data['startDate'] = startDate?.toIso8601String();
    data['endDate'] = endDate?.toIso8601String();
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    return data;
  }
}

class Location {
  String? address;
  Coordinates? coordinates;

  Location({this.address, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    coordinates = json['coordinates'] != null
        ? Coordinates.fromJson(json['coordinates'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.toJson();
    }
    return data;
  }
}

class Coordinates {
  num? lat;
  num? lng;

  Coordinates({this.lat, this.lng});

  Coordinates.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Financials {
  num? budgetTotal;
  num? costActual;
  num? valuePlanned;
  num? valueEarned;
  num? cpi;
  num? spi;

  Financials({
    this.budgetTotal,
    this.costActual,
    this.valuePlanned,
    this.valueEarned,
    this.cpi,
    this.spi,
  });

  Financials.fromJson(Map<String, dynamic> json) {
    budgetTotal = json['budget_total'];
    costActual = json['cost_actual'];
    valuePlanned = json['value_planned'];
    valueEarned = json['value_earned'];
    cpi = json['cpi'];
    spi = json['spi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['budget_total'] = budgetTotal;
    data['cost_actual'] = costActual;
    data['value_planned'] = valuePlanned;
    data['value_earned'] = valueEarned;
    data['cpi'] = cpi;
    data['spi'] = spi;
    return data;
  }
}
