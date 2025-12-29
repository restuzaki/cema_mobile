import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../data/models/project_model.dart';
import 'authenticated_client.dart';

class ProjectService {
  final AuthenticatedClient client;

  ProjectService({required this.client});

  String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:5000/api';

  /// Create a new project
  Future<Project> createProject({
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    String? adminId,
    String? managerId,
    String? clientId,
    String? serviceType,
    Location? location,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/projects');

      final payload = {
        'name': name,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'status': status,
        if (adminId != null) 'admin_id': adminId,
        if (managerId != null) 'manager_id': managerId,
        if (clientId != null) 'client_id': clientId,
        if (serviceType != null) 'serviceType': serviceType,
        if (location != null) 'location': location.toJson(),
      };

      final response = await client.post(url, body: jsonEncode(payload));

      final responseData = client.processResponse(response);

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        return Project.fromJson(responseData['data']);
      } else {
        throw Exception(
          'Failed to create project: ${responseData['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      throw Exception('Error creating project: $e');
    }
  }

  /// Get all projects
  Future<List<Project>> getProjects() async {
    try {
      final url = Uri.parse('$baseUrl/projects');

      final response = await client.get(url);
      final responseData = client.processResponse(response);

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final projects = (responseData['data'] as List)
            .map((projectJson) => Project.fromJson(projectJson))
            .toList();

        return projects;
      } else {
        throw Exception(
          'Failed to fetch projects: ${responseData['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching projects: $e');
    }
  }

  /// Get a single project by ID
  Future<Project> getProjectById(String projectId) async {
    try {
      final url = Uri.parse('$baseUrl/projects/$projectId');

      final response = await client.get(url);
      final responseData = client.processResponse(response);

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        return Project.fromJson(responseData['data']);
      } else {
        throw Exception(
          'Failed to fetch project: ${responseData['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching project: $e');
    }
  }

  /// Update a project
  Future<Project> updateProject({
    required String projectId,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    num? progress,
    Location? location,
    Financials? financials,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/projects/$projectId');

      final payload = <String, dynamic>{};
      if (name != null) payload['name'] = name;
      if (description != null) payload['description'] = description;
      if (startDate != null) payload['startDate'] = startDate.toIso8601String();
      if (endDate != null) payload['endDate'] = endDate.toIso8601String();
      if (status != null) payload['status'] = status;
      if (progress != null) payload['progress'] = progress;
      if (location != null) payload['location'] = location.toJson();
      if (financials != null) payload['financials'] = financials.toJson();

      final response = await client.put(url, body: jsonEncode(payload));

      final responseData = client.processResponse(response);

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        return Project.fromJson(responseData['data']);
      } else {
        throw Exception(
          'Failed to update project: ${responseData['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      throw Exception('Error updating project: $e');
    }
  }

  /// Delete a project
  Future<void> deleteProject(String projectId) async {
    try {
      final url = Uri.parse('$baseUrl/projects/$projectId');

      final response = await client.delete(url);
      final responseData = client.processResponse(response);

      if (responseData['status'] != 'success') {
        throw Exception(
          'Failed to delete project: ${responseData['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      throw Exception('Error deleting project: $e');
    }
  }

  /// Map UI status to backend status
  static String mapUiStatusToBackend(String uiStatus) {
    switch (uiStatus) {
      case 'Belum Dimulai':
        return 'LEAD';
      case 'Sedang Berjalan':
        return 'DESIGN';
      case 'Selesai':
        return 'COMPLETED';
      default:
        return 'LEAD';
    }
  }

  /// Map backend status to UI status
  static String mapBackendStatusToUi(String backendStatus) {
    switch (backendStatus) {
      case 'LEAD':
        return 'Belum Dimulai';
      case 'DESIGN':
      case 'CONSTRUCTION':
      case 'RETENTION':
        return 'Sedang Berjalan';
      case 'COMPLETED':
        return 'Selesai';
      case 'CANCELLED':
        return 'Dibatalkan';
      default:
        return 'Belum Dimulai';
    }
  }
}
