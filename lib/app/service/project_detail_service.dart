import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../data/model/task_model.dart';

class ProjectDetailService {
  final String _baseUrl = dotenv.env['API_KEY']!;

  Future<List<TaskModel>> getTasksByProjectId(String projectId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/tasks/project/$projectId'),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];

      return data.map((e) => TaskModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return TaskModel.fromJson(body['data']);
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/tasks/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return TaskModel.fromJson(body['data']);
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(String taskId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/tasks/$taskId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
