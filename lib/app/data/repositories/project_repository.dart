import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../service/authenticated_client.dart';
import '../models/project_model.dart';
import 'dart:async';

/// Exception thrown when an action is saved to the offline queue instead of the API.
class OfflineSuccessException implements Exception {
  final String message;
  OfflineSuccessException(this.message);
}

class ProjectRepository {
  final AuthenticatedClient client;
  final GetStorage _storage = GetStorage();

  // Storage Keys
  final String _cacheKey = 'offline_projects';
  final String _queueKey = 'sync_action_queue';

  ProjectRepository({required this.client});

  String get _baseUrl => dotenv.env['API_KEY'] ?? 'http://localhost:5000/api';

  /// Check if device has internet connection
  Future<bool> _isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  // ---------------------------------------------------------------------------
  // READ LOGIC
  // ---------------------------------------------------------------------------

  Future<List<Project>> getProjects() async {
    // 1. Try Network First
    try {
      if (await _isOnline()) {
        final url = Uri.parse('$_baseUrl/projects');
        final response = await client.get(url);

        if (response.statusCode == 200) {
          final Map<String, dynamic> body = json.decode(response.body);

          if (body['data'] is List) {
            final List<dynamic> data = body['data'];

            // Save to Cache
            await _storage.write(_cacheKey, data);

            return data.map((e) => Project.fromJson(e)).toList();
          } else {
            return [];
          }
        }
      }
      // If server returns non-200, we might want to throw or fall back.
      // For this pattern, let's fall back on error.
      throw Exception('Network failed or invalid response');
    } catch (e) {
      // 2. Fallback to Cache
      // print('Fetching projects from cache due to: $e');
      if (_storage.hasData(_cacheKey)) {
        final cachedData = _storage.read(_cacheKey);
        if (cachedData is List) {
          return cachedData.map((e) => Project.fromJson(e)).toList();
        }
      }
      // If no cache and network failed
      rethrow;
    }
  }
  // ---------------------------------------------------------------------------
  // WRITE LOGIC
  // ---------------------------------------------------------------------------

  Future<void> createProject(Map<String, dynamic> projectData) async {
    await _handleWriteAction(
      type: 'CREATE',
      apiUrl: '$_baseUrl/projects',
      method: 'POST',
      payload: projectData,
    );
  }

  Future<void> updateProject(
    String id,
    Map<String, dynamic> projectData,
  ) async {
    await _handleWriteAction(
      type: 'UPDATE',
      apiUrl: '$_baseUrl/projects/$id',
      method: 'PUT',
      payload: projectData,
      entityId: id,
    );
  }

  /// Core logic to decide between Online API Call or Offline Queue
  Future<void> _handleWriteAction({
    required String type,
    required String apiUrl,
    required String method,
    required Map<String, dynamic> payload,
    String? entityId,
  }) async {
    // 1. Check Connectivity
    if (await _isOnline()) {
      // ONLINE: Call API Directly
      final url = Uri.parse(apiUrl);
      dynamic response;

      try {
        if (method == 'POST') {
          response = await client.post(url, body: json.encode(payload));
        } else if (method == 'PUT') {
          response = await client.put(url, body: json.encode(payload));
        }

        if (response.statusCode >= 200 && response.statusCode < 300) {
          // Success: We could update local cache manually here for immediate consistency,
          // but calling getProjects() (refresh) in controller is safer/simpler for now.
          return;
        } else {
          throw Exception('API Error: ${response.statusCode} ${response.body}');
        }
      } catch (e) {
        // If API call fails (e.g. timeout), do we fallback to queue?
        // User requirement says: "IF OFFLINE". It doesn't explicitly say "If API Fails".
        // However, robust offline-first usually implies queueing on network errors too.
        // For now, adhering strictly to "IF OFFLINE" based on connectivity check,
        // but typically one might want to queue on SocketException too.
        rethrow;
      }
    } else {
      // OFFLINE: Add to Queue
      _addToQueue(type, payload, entityId);
      throw OfflineSuccessException('Action saved to offline queue.');
    }
  }

  void _addToQueue(
    String type,
    Map<String, dynamic> payload,
    String? entityId,
  ) {
    final List<dynamic> queue = _storage.read(_queueKey) ?? [];

    final action = {
      'id': 'TEMP_${DateTime.now().millisecondsSinceEpoch}',
      'type': type, // CREATE or UPDATE
      'payload': payload,
      'entityId': entityId, // Null for create
      'createdAt': DateTime.now().toIso8601String(),
    };

    queue.add(action);
    _storage.write(_queueKey, queue);
  }

  // ---------------------------------------------------------------------------
  // SYNC LOGIC
  // ---------------------------------------------------------------------------

  Future<void> syncPendingActions() async {
    if (!_storage.hasData(_queueKey)) return;

    List<dynamic> queue = _storage.read(_queueKey);
    if (queue.isEmpty) return;

    // print('Syncing ${queue.length} pending actions...');

    // We copy the queue to iterate safely, but we must modify the persistent storage queue carefully.
    // Strategy: Process one by one. If success, remove from storage immediately.
    // If fail, keep it (retry later).

    List<dynamic> remainingQueue = List.from(queue);
    bool anySuccess = false;

    for (int i = 0; i < queue.length; i++) {
      final item = queue[i];
      try {
        await _processSingleAction(item);

        // If successful, remove this specific item from the remaining list
        // We use ID to ensure we remove the correct one
        remainingQueue.removeWhere((q) => q['id'] == item['id']);
        anySuccess = true;
      } catch (e) {
        // print('Failed to sync item ${item['id']}: $e');
        // Keep in queue to retry later
      }
    }

    // Update storage with what's left
    await _storage.write(_queueKey, remainingQueue);

    // If we synced anything, refresh the main list
    if (anySuccess) {
      try {
        await getProjects();
      } catch (_) {}
    }
  }

  Future<void> _processSingleAction(Map<String, dynamic> action) async {
    final String type = action['type'];
    final Map<String, dynamic> payload = action['payload'];
    final String? entityId = action['entityId'];

    Uri url;
    dynamic response;

    if (type == 'CREATE') {
      url = Uri.parse('$_baseUrl/projects');
      response = await client.post(url, body: json.encode(payload));
    } else if (type == 'UPDATE' && entityId != null) {
      url = Uri.parse('$_baseUrl/projects/$entityId');
      response = await client.put(url, body: json.encode(payload));
    } else {
      return; // Unknown type, just drop? Or keep? treating as success to remove bad data.
    }

    if (response != null) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return; // Success
      } else {
        throw Exception('Sync failed: ${response.statusCode}');
      }
    }
  }
}
