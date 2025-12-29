import 'package:flutter/material.dart';
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

  void saveSettings() {
    final updatedData = {
      'name': nameEdit.text,
      'client': clientEdit.text,
      'description': descEdit.text,
      'budget': budgetEdit.text,
      'phase': phaseEdit.value,
      'startDate': startDateEdit.text,
      'endDate': endDateEdit.text,
    };
    print('Saving project settings: $updatedData');

    Get.snackbar(
      'Sukses',
      'Perubahan projek berhasil disimpan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success100,
      colorText: AppColors.success700,
    );
  }

  bool get canEdit => true;
}
