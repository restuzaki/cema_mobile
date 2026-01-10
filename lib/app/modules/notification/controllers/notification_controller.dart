import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../notification_model.dart';
import 'package:cema_mobile/app/service/local_notification_service.dart';
import 'package:cema_mobile/app/data/repositories/task_repository.dart';
import 'package:cema_mobile/app/data/repositories/expense_repository.dart';
import 'package:cema_mobile/app/service/authenticated_client.dart';
import 'package:cema_mobile/app/data/models/task_model.dart';
import 'package:cema_mobile/app/data/models/expense_model.dart';

class NotificationController extends GetxController {
  // Main notifications list for UI
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;

  // Separate lists for data
  final RxList<Task> urgentTasks = <Task>[].obs;
  final RxList<Expense> pendingExpenses = <Expense>[].obs;
  final RxList<Expense> approvedExpenses = <Expense>[].obs;
  final RxBool isLoading = true.obs;

  final TaskRepository _taskRepository = TaskRepository(
    client: AuthenticatedClient(),
  );
  final ExpenseRepository _expenseRepository = ExpenseRepository(
    client: AuthenticatedClient(),
  );
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
    _initFCMListener();
  }

  Future<void> loadNotifications() async {
    isLoading.value = true;
    try {
      print('🔄 Starting to load notifications...');

      // Fetch upcoming tasks
      try {
        print('📋 Fetching upcoming tasks...');
        final allTasks = await _taskRepository.getUpcomingTasks();
        print('📋 Received ${allTasks.length} upcoming tasks');
        urgentTasks.value = _filterUrgentTasks(allTasks);
        print('📋 Loaded ${urgentTasks.length} urgent tasks');
      } catch (e) {
        print('❌ Error fetching tasks: $e');
        urgentTasks.value = []; // Continue even if tasks fail
      }

      // Fetch pending expenses
      try {
        print('💰 Fetching pending expenses...');
        pendingExpenses.value = await _expenseRepository.getPendingExpenses();
        print('💰 Loaded ${pendingExpenses.length} pending expenses');
      } catch (e) {
        print('❌ Error fetching pending expenses: $e');
        pendingExpenses.value = []; // Continue even if expenses fail
      }

      // Fetch all expenses to get approved/rejected ones
      try {
        print('✅ Fetching all expenses...');
        final allExpenses = await _expenseRepository.getExpenses();
        print('✅ Received ${allExpenses.length} total expenses');
        approvedExpenses.value = allExpenses
            .where((e) => e.status == 'APPROVED' || e.status == 'REJECTED')
            .toList();
        print('✅ Loaded ${approvedExpenses.length} processed expenses');
      } catch (e) {
        print('❌ Error fetching all expenses: $e');
        approvedExpenses.value = []; // Continue even if approved expenses fail
      }

      // Convert to NotificationItem format for UI
      print('🔨 Building notification items...');
      _buildNotificationItems();
      print('✅ Built ${notifications.length} notification items');
    } catch (e) {
      print('❌ CRITICAL Error loading notifications: $e');
    } finally {
      isLoading.value = false;
      print('✅ Finished loading notifications');
    }
  }

  void _buildNotificationItems() {
    notifications.clear();

    // Add pending expenses (need action)
    for (var expense in pendingExpenses) {
      notifications.add(
        NotificationItem(
          title: expense.title ?? 'Pengeluaran',
          subtitle: 'Project: ${expense.projectId ?? 'Unknown'}',
          amount: 'Rp ${_formatCurrency(expense.amount ?? 0)}',
          hasAction: true,
          timestamp: 'Menunggu approval',
          expenseId: expense.id,
        ),
      );
    }

    // Add urgent tasks
    // PM can mark tasks as complete, staff just sees them as reminders
    final userRole = box.read('role') ?? 'staff';
    final isPM = userRole == 'project_manager' || userRole == 'admin';

    for (var task in urgentTasks) {
      final daysUntilDue = task.dueDate?.difference(DateTime.now()).inDays ?? 0;
      notifications.add(
        NotificationItem(
          title: task.title ?? 'Task',
          subtitle: 'Project: ${task.projectId!['name'] ?? 'Unknown'}',
          hasAction: isPM, // Only PM can mark as complete
          timestamp: 'Jatuh tempo dalam $daysUntilDue hari',
          taskId: task.id,
        ),
      );
    }
  }

  String _formatCurrency(num amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  String _getRelativeTime(DateTime? dateTime) {
    if (dateTime == null) return 'Baru saja';

    final diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) return '${diff.inDays} hari lalu';
    if (diff.inHours > 0) return '${diff.inHours} jam lalu';
    if (diff.inMinutes > 0) return '${diff.inMinutes} menit lalu';
    return 'Baru saja';
  }

  /// Filter tasks that are not DONE and have a due date in the future
  List<Task> _filterUrgentTasks(List<Task> tasks) {
    final now = DateTime.now();

    return tasks.where((task) {
      // Skip completed tasks
      if (task.status == 'DONE') return false;

      // Skip tasks without due date
      if (task.dueDate == null) return false;

      // Include all tasks with future due dates (no 7-day limit)
      return task.dueDate!.isAfter(now);
    }).toList();
  }

  /// Approve a task (update status to DONE)
  Future<void> approveTask(String taskId) async {
    try {
      await _taskRepository.updateTask(taskId, {'status': 'DONE'});
      await loadNotifications();

      Get.snackbar(
        'Sukses',
        'Task telah diselesaikan',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal approve task: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Approve an expense
  Future<void> approveExpense(String expenseId) async {
    try {
      await _expenseRepository.updateExpense(expenseId, {'status': 'APPROVED'});
      await loadNotifications();

      Get.snackbar(
        'Sukses',
        'Pengeluaran telah disetujui',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal approve expense: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Reject an expense with note
  Future<void> rejectExpense(String expenseId, String note) async {
    try {
      await _expenseRepository.updateExpense(expenseId, {
        'status': 'REJECTED',
        'rejection_note': note,
      });
      await loadNotifications();

      Get.snackbar(
        'Sukses',
        'Pengeluaran telah ditolak',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal reject expense: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// FCM Listener (for foreground messages)
  void _initFCMListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? 'Notifikasi';
      final body = message.notification?.body ?? '';

      LocalNotificationService.show(title: title, body: body);

      // Reload notifications when new message arrives
      loadNotifications();
    });
  }

  /// Get FCM token
  Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }
}
