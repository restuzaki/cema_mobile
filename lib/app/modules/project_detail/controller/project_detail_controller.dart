import 'package:get/get.dart';
import '../../../data/controllers/data_controller.dart';
import '../../../data/models/project_model.dart';

class ProjectDetailController extends GetxController {
  final DataController dataController = Get.find<DataController>();

  var mainTabIndex = 0.obs;
  var taskFilterIndex = 0.obs;
  var expenseFilterIndex = 0.obs;

  ProjectModel? get currentProject => dataController.selectedProject.value;

  List<TaskModel> get tasks {
    if (currentProject == null) return [];
    return dataController.getTasksByProject(currentProject!.id);
  }

  List<ExpenseModel> get expenses {
    if (currentProject == null) return [];
    return dataController.getExpensesByProject(currentProject!.id);
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
