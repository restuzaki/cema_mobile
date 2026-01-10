import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../service/authenticated_client.dart';
import '../models/expense_model.dart';
import '../../core/exceptions/offline_success_exception.dart';

class ExpenseRepository {
  final AuthenticatedClient client;
  final GetStorage _storage = GetStorage();

  // Storage Keys
  final String _cacheKey = 'offline_expenses';
  final String _queueKey =
      'sync_action_queue'; // Shared queue key with ProjectRepository

  ExpenseRepository({required this.client});

  String get _baseUrl => dotenv.env['API_KEY'] ?? 'http://10.0.2.2:5000/api';

  /// Check if device has internet connection
  Future<bool> _isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  // ---------------------------------------------------------------------------
  // READ LOGIC
  // ---------------------------------------------------------------------------

  Future<List<Expense>> getExpenses({String? projectId}) async {
    // 1. Try Network First
    try {
      if (await _isOnline()) {
        final uri = Uri.parse('$_baseUrl/expenses/project/$projectId');

        final response = await client.get(uri);

        if (response.statusCode == 200) {
          final Map<String, dynamic> body = json.decode(response.body);

          if (body['data'] is List) {
            final List<dynamic> data = body['data'];

            // Save to Cache (Simple caching strategy: if querying all or specific project,
            // we might want a better cache structure, but for now caching generic list)
            // Note: Caching logic here might overwrite if filtering.
            // For MVP/Offline basic, we might skip caching filtered results or store separately.
            // Let's only cache if NO filter is applied (all expenses) or maybe append?
            // For simplicity in this task, we won't deeply cache filtered results,
            // but we can cache the last successful fetch.
            if (projectId == null) {
              await _storage.write(_cacheKey, data);
            }

            return data.map((e) => Expense.fromJson(e)).toList();
          } else {
            return [];
          }
        }
      }
      throw Exception('Network failed or invalid response');
    } catch (e) {
      // 2. Fallback to Cache
      if (_storage.hasData(_cacheKey)) {
        final cachedData = _storage.read(_cacheKey);
        if (cachedData is List) {
          var expenses = cachedData.map((e) => Expense.fromJson(e)).toList();
          if (projectId != null) {
            expenses = expenses.where((e) => e.projectId == projectId).toList();
          }
          return expenses;
        }
      }
      rethrow;
    }
  }

  /// Get all pending expenses (status = PENDING)
  /// Uses GET /expenses and filters client-side since backend already filters by role
  Future<List<Expense>> getPendingExpenses() async {
    try {
      if (await _isOnline()) {
        final uri = Uri.parse('$_baseUrl/expenses');
        final response = await client.get(uri);

        if (response.statusCode == 200) {
          final Map<String, dynamic> body = json.decode(response.body);

          if (body['data'] is List) {
            final List<dynamic> data = body['data'];
            // Filter for PENDING status client-side
            return data
                .map((e) => Expense.fromJson(e))
                .where((expense) => expense.status == 'PENDING')
                .toList();
          } else {
            return [];
          }
        }
      }
      throw Exception('Network failed or invalid response');
    } catch (e) {
      print('Error fetching pending expenses: $e');
      return []; // Return empty list on error
    }
  }

  // ---------------------------------------------------------------------------
  // WRITE LOGIC
  // ---------------------------------------------------------------------------

  Future<void> createExpense(Map<String, dynamic> expenseData) async {
    await _handleWriteAction(
      type:
          'CREATE_EXPENSE', // Distinct type for queue processor if needed, or reuse 'CREATE' if generic
      // However, project_repo uses 'CREATE' which implies Project.
      // We should probably share the queue but differentiate resource type if the queue processor is shared.
      // Looking at ProjectRepository, it processes 'CREATE' as /projects.
      // Ideally we should refactor to a generic SyncService, but for now getting it working:
      // We will allow ProjectRepository to own the sync logic? Or duplicate?
      // Better: Use a distinct type 'CREATE_EXPENSE' and ensure Sync Logic handles it.
      // BUT ProjectRepository sync logic currently only handles CREATE/UPDATE for projects.
      // We need to update Sync Logic too.
      // For this task, I will implement local sync logic in ExpenseRepository too,
      // but they share the same queue key. This might cause conflict if both try to sync.
      // SAFE APPROACH: ExpenseRepository manages its own queue items?
      // Or we accept we need to update ProjectRepo.
      // Let's use the same queue key but we need a central sync service.
      // Since I can't refactor everything, I will use the SAME queue key but handle my own types in this repo's sync.
      // Warning: If ProjectRepository syncs, it might discard unknown types.
      // Validating ProjectRepository: "else { return; }" -> It ignores unknown types. Good.
      apiUrl: '$_baseUrl/expenses',
      method: 'POST',
      payload: expenseData,
    );
  }

  Future<void> _handleWriteAction({
    required String type,
    required String apiUrl,
    required String method,
    required Map<String, dynamic> payload,
  }) async {
    if (await _isOnline()) {
      final url = Uri.parse(apiUrl);
      dynamic response;

      try {
        if (method == 'POST') {
          response = await client.post(url, body: json.encode(payload));
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
      _addToQueue(type, payload);
      throw OfflineSuccessException('Expense saved to offline queue.');
    }
  }

  void _addToQueue(String type, Map<String, dynamic> payload) {
    final List<dynamic> queue = _storage.read(_queueKey) ?? [];

    final action = {
      'id': 'TEMP_EXP_${DateTime.now().millisecondsSinceEpoch}',
      'type': type,
      'payload': payload,
      'createdAt': DateTime.now().toIso8601String(),
    };

    queue.add(action);
    _storage.write(_queueKey, queue);
  }

  Future<void> updateExpense(
    String expenseId,
    Map<String, dynamic> updateData,
  ) async {
    if (await _isOnline()) {
      final url = Uri.parse('$_baseUrl/expenses/$expenseId');

      try {
        final response = await client.put(url, body: json.encode(updateData));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return;
        } else {
          throw Exception('API Error: ${response.statusCode} ${response.body}');
        }
      } catch (e) {
        rethrow;
      }
    } else {
      throw Exception('Cannot update expense while offline');
    }
  }

  // ---------------------------------------------------------------------------
  // SYNC LOGIC
  // ---------------------------------------------------------------------------

  Future<void> syncPendingExpenses() async {
    if (!_storage.hasData(_queueKey)) return;

    List<dynamic> queue = _storage.read(_queueKey);
    if (queue.isEmpty) return;

    List<dynamic> remainingQueue = List.from(queue);
    bool anySuccess = false;

    // Filter only EXPENSE types to process
    final expenseActions = queue
        .where((q) => q['type'] == 'CREATE_EXPENSE')
        .toList();

    for (var action in expenseActions) {
      try {
        await _processSingleAction(action);
        // Remove from persistent queue
        remainingQueue.removeWhere((q) => q['id'] == action['id']);
        anySuccess = true;
      } catch (e) {
        // failed, keep
      }
    }

    await _storage.write(_queueKey, remainingQueue);
  }

  Future<void> _processSingleAction(Map<String, dynamic> action) async {
    final String type = action['type'];
    final Map<String, dynamic> payload = action['payload'];

    if (type == 'CREATE_EXPENSE') {
      final url = Uri.parse('$_baseUrl/expenses');
      final response = await client.post(url, body: json.encode(payload));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      } else {
        throw Exception('Sync failed: ${response.statusCode}');
      }
    }
  }
}
