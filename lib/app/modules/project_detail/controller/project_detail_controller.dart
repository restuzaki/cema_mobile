import 'package:flutter/material.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../service/authenticated_client.dart';
import 'package:get/get.dart';
import 'package:cema_mobile/app/design_system/design_system.dart';
import '../../../data/controllers/data_controller.dart';
import '../../../data/models/project_model.dart';
import '../../../data/model/task_model.dart';
import '../../../data/model/expense_model.dart';

class ProjectDetailController extends GetxController {
  final DataController dataController = Get.find<DataController>();

  var mainTabIndex = 0.obs;
  var taskFilterIndex = 0.obs;
  var financeFilterIndex = 0.obs;

  var isLoading = true.obs;

  Project? get currentProject => dataController.selectedProject.value;

  // Tabs for Filter
  final List<String> taskFilters = [
    'Semua',
    'Berlangsung',
    'Terlambat',
    'Selesai',
  ];
  final List<String> financeFilters = ['Semua', 'Pemasukan', 'Pengeluaran'];

  List<TaskModel> get tasks =>
      dataController.getTasksByProject(currentProject?.id ?? '');

  List<ExpenseModel> get expenses =>
      dataController.getExpensesByProject(currentProject?.id ?? '');

  List<TaskModel> get filteredTasks {
    final idx = taskFilterIndex.value;
    if (idx == 0) return tasks;
    if (idx == 1) return tasks.where((t) => t.status == 'ongoing').toList();
    if (idx == 2) return tasks.where((t) => t.status == 'late').toList();
    return tasks.where((t) => t.status == 'done').toList();
  }

  List<ExpenseModel> get filteredExpenses {
    final idx = financeFilterIndex.value;
    if (idx == 0) {
      return expenses.where((e) => e.status == 'pending').toList();
    }
    return expenses;
  }

  void changeMainTab(int index) => mainTabIndex.value = index;
  void changeTaskFilter(int index) => taskFilterIndex.value = index;
  void changeFinanceFilter(int index) => financeFilterIndex.value = index;

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void acceptExpense(String expenseId) {
    dataController.acceptExpense(expenseId);
  }

  void rejectExpense(String expenseId) {
    dataController.rejectExpense(expenseId);
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
    // Initialize form with current data if available
    ever(dataController.selectedProject, (_) => _initSettingsForm());
    _initSettingsForm();
    fetchProjectDetails();
  }

  void fetchProjectDetails() async {
    isLoading.value = true;
    final id = currentProject?.id;
    if (id == null) {
      isLoading.value = false;
      return;
    }
    try {
      final projects = await _repository.getProjects();
      final freshProject = projects.firstWhere(
        (p) => p.id == id,
        orElse: () => throw Exception('Project not found'),
      );

      dataController.selectProject(freshProject); // Updates the reactive value
      dataController.updateProject(
        id,
        freshProject,
      ); // Updates the list in DataController
    } catch (e) {
      print("Error fetching project details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _initSettingsForm() {
    final project = currentProject;
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

  // Repository
  final ProjectRepository _repository = ProjectRepository(
    client: AuthenticatedClient(),
  );

  void saveSettings() async {
    final project = currentProject;
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

    try {
      // 2. Call API
      await _repository.updateProject(project.id!, payload);

      // 3. Update Local State (Immediate Feedback)
      final updatedProject = Project.fromJson({
        ...project.toJson(),
        ...payload,
      });

      dataController.updateProject(project.id!, updatedProject);
      dataController.selectProject(updatedProject);

      // 4. Fetch Fresh Data (Ensure Consistency)
      fetchProjectDetails();

      Get.snackbar(
        'Sukses',
        'Perubahan projek berhasil disimpan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success100,
        colorText: AppColors.success700,
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
