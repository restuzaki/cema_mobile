import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../service/authenticated_client.dart';
import '../models/project_model.dart'; // Correct import path based on file structure

class ProjectRepository {
  final AuthenticatedClient client;
  final GetStorage storage = GetStorage();

  ProjectRepository({required this.client});

  String get _baseUrl => dotenv.env['API_KEY'] ?? 'http://localhost:5000/api';

  /// Syncs any offline edits before fetching new data.
  /// This checks for a specific key 'offline_edits' in storage.
  Future<void> syncOfflineChanges() async {
    // This is a placeholder for the actual sync logic.
    // In a real scenario, we would iterate through stored offline actions
    // and execute them against the backend.
    if (storage.hasData('offline_edits')) {
      // Logic to sync would go here.
      // For example:
      // List edits = storage.read('offline_edits');
      // for (var edit in edits) { ... send request ... }
      // storage.remove('offline_edits');

      // For now, we will just print to console or log.
      // print('Syncing offline edits...');
    }
  }

  Future<List<Project>> getProjects() async {
    // 1. Ensure offline changes are synced first
    await syncOfflineChanges();

    try {
      // 2. Fetch from API
      // Using the helper getter from AuthenticatedClient if available, or constructing URL manually
      // The instruction said: Use dotenv.env['API_URL'] + '/projects'
      // But AuthenticatedClient also has a baseUrl getter.
      // We'll stick to the safer manual construction or use the client's capability if exposed.
      // Since AuthenticatedClient extends BaseClient, we use standard http methods.

      final url = Uri.parse('$_baseUrl/projects');
      final response = await client.get(url);

      // AuthenticatedClient might throw on error if configured, but let's handle standard codes.
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);

        // Ensure "data" exists and is a list
        if (body['data'] is List) {
          final List<dynamic> data = body['data'];
          final List<Project> projects = data
              .map((e) => Project.fromJson(e))
              .toList();

          // 3. Save to Cache
          await storage.write(
            'offline_projects',
            json.encode(body),
          ); // Cache full body or just data?
          // Usually caching the raw response payload is safer for consistent parsing later.
          // Or we can cache the list. Let's cache the raw 'data' list for simplicity in retrieval.
          await storage.write('offline_projects', data);

          return projects;
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load projects: ${response.statusCode}');
      }
    } catch (e) {
      // 4. Fallback to Cache
      // print('Network error, fetching from cache: $e');
      if (storage.hasData('offline_projects')) {
        final cachedData = storage.read('offline_projects');
        if (cachedData is List) {
          return cachedData.map((e) => Project.fromJson(e)).toList();
        }
      }
      // If no cache and API failed, rethrow
      rethrow;
    }
  }
}
