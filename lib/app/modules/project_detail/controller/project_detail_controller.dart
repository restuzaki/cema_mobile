import 'package:flutter/material.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../data/repositories/expense_repository.dart';
import '../../../service/authenticated_client.dart';
import 'package:get/get.dart';
import 'package:cema_mobile/app/design_system/design_system.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/expense_model.dart';
import '../../../service/local_notification_service.dart';

class ProjectDetailController extends GetxController {
  var mainTabIndex = 0.obs;
  var taskFilterIndex = 0.obs;
  var financeFilterIndex = 0.obs;

  var isLoading = true.obs;

  // Project received from route arguments
  final Rx<Project?> currentProject = Rx<Project?>(null);

  // Tabs for Filter
  final List<String> taskFilters = [
    'Semua',
    'Berlangsung',
    'Terlambat',
    'Selesai',
  ];
  final List<String> financeFilters = ['Semua', 'Pemasukan', 'Pengeluaran'];

  // Task and Expense data loaded from repositories
  final RxList<Task> tasks = <Task>[].obs;
  final RxList<Expense> expenses = <Expense>[].obs;

  List<Task> get filteredTasks {
    final idx = taskFilterIndex.value;
    if (idx == 0) return tasks;
    if (idx == 1) return tasks.where((t) => t.status == 'IN_PROGRESS').toList();
    if (idx == 2) {
      // Late tasks = overdue tasks
      final now = DateTime.now();
      return tasks
          .where(
            (t) =>
                t.dueDate != null &&
                t.dueDate!.isBefore(now) &&
                t.status != 'DONE',
          )
          .toList();
    }
    return tasks.where((t) => t.status == 'DONE').toList();
  }

  List<Expense> get filteredExpenses {
    final idx = financeFilterIndex.value;
    if (idx == 0) {
      return expenses.where((e) => e.status == 'PENDING').toList();
    }
    return expenses;
  }

  void changeMainTab(int index) => mainTabIndex.value = index;
  void changeTaskFilter(int index) => taskFilterIndex.value = index;
  void changeFinanceFilter(int index) => financeFilterIndex.value = index;

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // Financial Helpers
  String formatCurrency(num? amount) {
    if (amount == null) return 'Rp 0';
    final str = amount.toStringAsFixed(0);
    final parts = <String>[];
    for (var i = str.length; i > 0; i -= 3) {
      final start = i - 3 < 0 ? 0 : i - 3;
      parts.insert(0, str.substring(start, i));
    }
    return 'Rp ${parts.join('.')}';
  }

  String formatMetric(num? value) {
    if (value == null) return '0.00';
    return value.toStringAsFixed(2);
  }

  (Color bgColor, Color textColor) getMetricColors(num? value, bool isRatio) {
    if (value == null || value == 0) {
      return (AppColors.neutral100, AppColors.neutral700);
    }

    if (isRatio) {
      // For CPI and SPI: >= 1.0 is good, 0.8-1.0 is warning, < 0.8 is bad
      if (value >= 1.0) {
        return (AppColors.primary100, AppColors.primary500);
      } else if (value >= 0.8) {
        return (AppColors.warning100, AppColors.warning500);
      } else {
        return (AppColors.error100, AppColors.error500);
      }
    } else {
      // For other metrics, neutral color
      return (AppColors.neutral100, AppColors.neutral700);
    }
  }

  void acceptExpense(String expenseId) async {
    // TODO: Implement expense approval via API
    // For now, just show a message
    Get.snackbar(
      'Info',
      'Expense approval feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void rejectExpense(String expenseId) async {
    // TODO: Implement expense rejection via API
    // For now, just show a message
    Get.snackbar(
      'Info',
      'Expense rejection feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Settings Form Controllers
  final nameEdit = TextEditingController();
  final clientEdit = TextEditingController();
  final descEdit = TextEditingController();
  final budgetEdit = TextEditingController();
  final startDateEdit = TextEditingController();
  final endDateEdit = TextEditingController();
  var phaseEdit = 'Development'.obs;

  @override
  void onInit() {
    super.onInit();
    // Get project from route arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['project'] != null) {
      currentProject.value = args['project'] as Project;
    }

    // Initialize form with current data if available
    ever(currentProject, (_) => _initSettingsForm());
    _initSettingsForm();
    fetchProjectDetails();
  }

  void fetchProjectDetails() async {
    isLoading.value = true;
    final id = currentProject.value?.id;
    if (id == null) {
      isLoading.value = false;
      return;
    }
    try {
      // Fetch project details
      final projects = await _projectRepository.getProjects();
      final freshProject = projects.firstWhere(
        (p) => p.id == id,
        orElse: () => throw Exception('Project not found'),
      );

      // Update local project state
      currentProject.value = freshProject;

      // Fetch tasks for this project
      await fetchTasks();

      // Fetch expenses for this project
      await fetchExpenses();
    } catch (e) {
      print("Error fetching project details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTasks() async {
    final projectId = currentProject.value?.id;
    if (projectId == null) return;

    try {
      final fetchedTasks = await _taskRepository.getTasks(projectId);
      tasks.value = fetchedTasks;
    } catch (e) {
      print('Error fetching tasks: $e');
      // On error, keep existing cached data if any
    }
  }

  Future<void> fetchExpenses() async {
    final projectId = currentProject.value?.id;
    if (projectId == null) return;

    try {
      final fetchedExpenses = await _expenseRepository.getExpenses(
        projectId: projectId,
      );
      expenses.value = fetchedExpenses;
    } catch (e) {
      print('Error fetching expenses: $e');
      // On error, keep existing cached data if any
    }
  }

  void _initSettingsForm() {
    final project = currentProject.value;
    if (project != null) {
      nameEdit.text = project.name ?? '';
      clientEdit.text = project.clientName ?? '';
      descEdit.text = project.description ?? '';
      budgetEdit.text = project.financials?.budgetTotal?.toString() ?? '0';

      // Phase is missing in new Project model, defaulting or keeping existing logic if possible.
      // For now, we leave it as default or could map from status if needed.
      // phaseEdit.value = project.phase;

      if (project.startDate != null) {
        onDateSelected(startDateEdit, project.startDate!);
      }
      if (project.endDate != null) {
        onDateSelected(endDateEdit, project.endDate!);
      }
    }
  }

  void onDateSelected(TextEditingController controller, DateTime date) {
    controller.text =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Repositories
  final ProjectRepository _projectRepository = ProjectRepository(
    client: AuthenticatedClient(),
  );
  final TaskRepository _taskRepository = TaskRepository(
    client: AuthenticatedClient(),
  );
  final ExpenseRepository _expenseRepository = ExpenseRepository(
    client: AuthenticatedClient(),
  );

  void saveSettings() async {
    final project = currentProject.value;
    if (project == null || project.id == null) return;

    // 1. Prepare Data
    // Parse Dates
    DateTime? start;
    DateTime? end;
    try {
      if (startDateEdit.text.isNotEmpty)
        start = DateTime.parse(startDateEdit.text);
      if (endDateEdit.text.isNotEmpty) end = DateTime.parse(endDateEdit.text);
    } catch (_) {}

    // Prepare Financials
    // We want to update budget but keep other existing financials if possible
    // Since PUT usually replaces, we should ideally construct the full object or what backend expects.
    // Assuming backend handles partial updates or we send what we have.
    Map<String, dynamic> financialsPayload = {};
    if (project.financials != null) {
      financialsPayload = project.financials!.toJson();
    }
    financialsPayload['budget_total'] = num.tryParse(budgetEdit.text) ?? 0;

    final Map<String, dynamic> payload = {
      'name': nameEdit.text,
      'clientName': clientEdit.text,
      'description': descEdit.text,
      'financials': financialsPayload,
      // 'phase': phaseEdit.value, // Not in model yet
      if (start != null) 'startDate': start.toIso8601String(),
      if (end != null) 'endDate': end.toIso8601String(),
    };

    // Track what changed
    List<String> changedFields = [];
    if (nameEdit.text != project.name) {
      changedFields.add('name');
    }
    if (clientEdit.text != (project.clientName ?? '')) {
      changedFields.add('client');
    }
    if (descEdit.text != (project.description ?? '')) {
      changedFields.add('description');
    }
    if (start != null && start != project.startDate) {
      changedFields.add('start date');
    }
    if (end != null && end != project.endDate) {
      changedFields.add('end date');
    }
    final oldBudget = project.financials?.budgetTotal ?? 0;
    final newBudget = num.tryParse(budgetEdit.text) ?? 0;
    if (newBudget != oldBudget) {
      changedFields.add('budget');
    }

    try {
      // 2. Call API
      await _projectRepository.updateProject(project.id!, payload);

      // 3. Update Local State (Immediate Feedback)
      final updatedProject = Project.fromJson({
        ...project.toJson(),
        ...payload,
      });

      currentProject.value = updatedProject;

      // 4. Fetch Fresh Data (Ensure Consistency)
      fetchProjectDetails();

      // Show success snackbar
      Get.snackbar(
        'Sukses',
        'Perubahan projek berhasil disimpan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success100,
        colorText: AppColors.success700,
      );

      // Show notification with changed fields
      final changesText = changedFields.isEmpty
          ? 'No changes detected'
          : changedFields.join(', ');

      LocalNotificationService.show(
        title: '📝 Project Updated',
        body: '${project.name} has been updated. Changes: $changesText',
        payload: {
          'type': 'project_update',
          'project_id': project.id ?? '',
          'project_name': project.name ?? '',
          'changed_fields': changesText,
        },
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal menyimpan perubahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error100,
        colorText: AppColors.error700,
      );
    }
  }

  bool get canEdit => true;
}
