import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../service/authenticated_client.dart';
import '../models/task_model.dart';
import '../../core/exceptions/offline_success_exception.dart';
import 'dart:async';

class TaskRepository {
  final AuthenticatedClient client;
  final GetStorage _storage = GetStorage();

  // Storage Keys
  final String _queueKey = 'sync_task_queue';

  TaskRepository({required this.client});

  String get _baseUrl => dotenv.env['API_KEY'] ?? 'http://localhost:5000/api';

  /// Check if device has internet connection
  Future<bool> _isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  // ---------------------------------------------------------------------------
  // READ LOGIC
  // ---------------------------------------------------------------------------

  Future<List<Task>> getTasks(String projectId) async {
    final String cacheKey = 'offline_tasks_$projectId';

    // 1. Try Network First
    try {
      if (await _isOnline()) {
        final url = Uri.parse('$_baseUrl/tasks/project/$projectId');
        final response = await client.get(url);

        if (response.statusCode == 200) {
          final Map<String, dynamic> body = json.decode(response.body);

          if (body['data'] is List) {
            final List<dynamic> data = body['data'];

            // Save to Cache
            await _storage.write(cacheKey, data);

            return data.map((e) => Task.fromJson(e)).toList();
          } else {
            return [];
          }
        }
      }
      throw Exception('Network failed or invalid response');
    } catch (e) {
      // 2. Fallback to Cache
      if (_storage.hasData(cacheKey)) {
        final cachedData = _storage.read(cacheKey);
        if (cachedData is List) {
          return cachedData.map((e) => Task.fromJson(e)).toList();
        }
      }
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // WRITE LOGIC
  // ---------------------------------------------------------------------------

  Future<void> createTask(Map<String, dynamic> taskData) async {
    await _handleWriteAction(
      type: 'CREATE',
      apiUrl: '$_baseUrl/tasks',
      method: 'POST',
      payload: taskData,
    );
  }

  Future<void> updateTask(String id, Map<String, dynamic> taskData) async {
    await _handleWriteAction(
      type: 'UPDATE',
      apiUrl: '$_baseUrl/tasks/$id',
      method: 'PUT',
      payload: taskData,
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
          return;
        } else {
          throw Exception('API Error: ${response.statusCode} ${response.body}');
        }
      } catch (e) {
        rethrow;
      }
    } else {
      // OFFLINE: Add to Queue
      _addToQueue(type, payload, entityId);
      throw OfflineSuccessException('Task saved to offline queue.');
    }
  }

  void _addToQueue(
    String type,
    Map<String, dynamic> payload,
    String? entityId,
  ) {
    final List<dynamic> queue = _storage.read(_queueKey) ?? [];

    final action = {
      'id': 'TEMP_TASK_${DateTime.now().millisecondsSinceEpoch}',
      'type': type, // CREATE or UPDATE
      'payload': payload,
      'entityId': entityId,
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

    List<dynamic> remainingQueue = List.from(queue);

    for (int i = 0; i < queue.length; i++) {
      final item = queue[i];
      try {
        await _processSingleAction(item);
        remainingQueue.removeWhere((q) => q['id'] == item['id']);
      } catch (e) {
        // Keep in queue
      }
    }

    await _storage.write(_queueKey, remainingQueue);
  }

  Future<void> _processSingleAction(Map<String, dynamic> action) async {
    final String type = action['type'];
    final Map<String, dynamic> payload = action['payload'];
    final String? entityId = action['entityId'];

    Uri url;
    dynamic response;

    if (type == 'CREATE') {
      url = Uri.parse('$_baseUrl/tasks');
      response = await client.post(url, body: json.encode(payload));
    } else if (type == 'UPDATE' && entityId != null) {
      url = Uri.parse('$_baseUrl/tasks/$entityId');
      response = await client.put(url, body: json.encode(payload));
    } else {
      return;
    }

    if (response != null) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        throw Exception('Sync failed: ${response.statusCode}');
      }
    }
  }
}
