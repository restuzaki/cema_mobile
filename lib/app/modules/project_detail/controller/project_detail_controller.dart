import 'package:get/get.dart';
import '../../../data/controllers/data_controller.dart';
import '../../../data/models/project_model.dart';

class ProjectDetailController extends GetxController {
  final DataController dataController = Get.find<DataController>();

  var mainTabIndex = 0.obs;
  var taskFilterIndex = 0.obs;
  var expenseFilterIndex = 0.obs;

  // Dummy data if no project selected
  ProjectModel? get currentProject =>
      dataController.selectedProject.value ?? _getDummyProject();

  ProjectModel _getDummyProject() {
    return ProjectModel(
      id: 'dummy_proj',
      name: 'Project Dummy',
      phase: 'Development',
      client: 'PT Example',
      status: 'normal',
      cpi: 1.0,
      spi: 1.0,
    );
  }

  List<TaskModel> get tasks {
    if (currentProject == null) return _getDummyTasks();
    final projectTasks = dataController.getTasksByProject(currentProject!.id);
    return projectTasks.isEmpty ? _getDummyTasks() : projectTasks;
  }

  List<ExpenseModel> get expenses {
    if (currentProject == null) return _getDummyExpenses();
    final projectExpenses = dataController.getExpensesByProject(
      currentProject!.id,
    );
    return projectExpenses.isEmpty ? _getDummyExpenses() : projectExpenses;
  }

  List<TaskModel> _getDummyTasks() {
    return [
      TaskModel(
        id: 'dummy_task_1',
        projectId: 'dummy_proj',
        title: 'Membuat Design UI/UX',
        responsibleName: 'Ahmad Zaki',
        description: 'Membuat design interface untuk aplikasi mobile',
        startDate: DateTime(2025, 11, 1),
        dueDate: DateTime(2025, 11, 18),
        phase: 'Design',
        status: 'ongoing',
      ),
      TaskModel(
        id: 'dummy_task_2',
        projectId: 'dummy_proj',
        title: 'Implementasi Backend API',
        responsibleName: 'Budi Santoso',
        description: 'Membuat REST API untuk sistem manajemen',
        startDate: DateTime(2025, 11, 10),
        dueDate: DateTime(2025, 11, 25),
        phase: 'Development',
        status: 'ongoing',
      ),
      TaskModel(
        id: 'dummy_task_3',
        projectId: 'dummy_proj',
        title: 'Testing Sistem Login',
        responsibleName: 'Citra Dewi',
        description: 'Melakukan testing untuk fitur authentication',
        startDate: DateTime(2025, 11, 5),
        dueDate: DateTime(2025, 11, 15),
        phase: 'Testing',
        status: 'late',
      ),
      TaskModel(
        id: 'dummy_task_4',
        projectId: 'dummy_proj',
        title: 'Setup Database',
        responsibleName: 'Doni Pratama',
        description: 'Konfigurasi database PostgreSQL',
        startDate: DateTime(2025, 10, 20),
        dueDate: DateTime(2025, 11, 1),
        phase: 'Infrastructure',
        status: 'done',
      ),
      TaskModel(
        id: 'dummy_task_5',
        projectId: 'dummy_proj',
        title: 'Code Review Sprint 1',
        responsibleName: 'Eka Putri',
        description: 'Review code untuk sprint pertama',
        startDate: DateTime(2025, 11, 20),
        dueDate: DateTime(2025, 11, 22),
        phase: 'Development',
        status: 'menunggu',
      ),
    ];
  }

  List<ExpenseModel> _getDummyExpenses() {
    return [
      ExpenseModel(
        id: 'dummy_exp_1',
        projectId: 'dummy_proj',
        amount: 15000000,
        description: 'Pembelian lisensi software development tools',
        status: 'pending',
        createdAt: DateTime(2025, 11, 15),
      ),
      ExpenseModel(
        id: 'dummy_exp_2',
        projectId: 'dummy_proj',
        amount: 8500000,
        description: 'Biaya hosting dan domain untuk 1 tahun',
        status: 'pending',
        createdAt: DateTime(2025, 11, 16),
      ),
      ExpenseModel(
        id: 'dummy_exp_3',
        projectId: 'dummy_proj',
        amount: 25000000,
        description: 'Pembayaran konsultan IT security',
        status: 'approved',
        createdAt: DateTime(2025, 11, 10),
      ),
      ExpenseModel(
        id: 'dummy_exp_4',
        projectId: 'dummy_proj',
        amount: 12000000,
        description: 'Pembelian server untuk staging environment',
        status: 'approved',
        createdAt: DateTime(2025, 11, 5),
      ),
      ExpenseModel(
        id: 'dummy_exp_5',
        projectId: 'dummy_proj',
        amount: 3500000,
        description: 'Biaya meeting dan koordinasi tim',
        status: 'pending',
        createdAt: DateTime(2025, 11, 17),
      ),
    ];
  }

  List<TaskModel> get filteredTasks {
    final idx = taskFilterIndex.value;
    if (idx == 0) return tasks;
    if (idx == 1) return tasks.where((t) => t.status == 'ongoing').toList();
    if (idx == 2) return tasks.where((t) => t.status == 'late').toList();
    return tasks.where((t) => t.status == 'done').toList();
  }

  List<ExpenseModel> get filteredExpenses {
    final idx = expenseFilterIndex.value;
    if (idx == 0) return expenses.where((e) => e.status == 'pending').toList();
    return expenses;
  }

  void changeMainTab(int index) => mainTabIndex.value = index;

  void changeTaskFilter(int index) => taskFilterIndex.value = index;

  void changeExpenseFilter(int index) => expenseFilterIndex.value = index;

  void acceptExpense(String expenseId) {
    dataController.acceptExpense(expenseId);
  }

  void rejectExpense(String expenseId) {
    dataController.rejectExpense(expenseId);
  }
}
