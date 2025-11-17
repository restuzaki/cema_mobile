import 'package:get/get.dart';

class ProjectDetailController extends GetxController {
  var mainTabIndex = 0.obs;
  var taskFilterIndex = 0.obs;
  var expenseFilterIndex = 0.obs;

  final RxList<Map<String, dynamic>> tasks = <Map<String, dynamic>>[
    {
      'title': 'Task',
      'project': 'Project',
      'dueDate': '18 Des',
      'phase': 'Phase',
      'status': 'ongoing',
    },
    {
      'title': 'Task',
      'project': 'Project',
      'dueDate': '20 Des',
      'phase': 'Phase',
      'status': 'ongoing',
    },
    {
      'title': 'Task',
      'project': 'Project',
      'dueDate': '10 Des',
      'phase': 'Phase',
      'status': 'late',
    },
  ].obs;

  final RxList<Map<String, dynamic>> expenses = <Map<String, dynamic>>[
    {
      'amount': 'Rp 150.000.000',
      'description': 'Description',
      'status': 'pending',
    },
    {
      'amount': 'Rp 150.000.000',
      'description': 'Description',
      'status': 'approved',
    },
  ].obs;

  List<Map<String, dynamic>> get filteredTasks {
    final idx = taskFilterIndex.value;
    if (idx == 0) return tasks;
    if (idx == 1) return tasks.where((t) => t['status'] == 'ongoing').toList();
    if (idx == 2) return tasks.where((t) => t['status'] == 'late').toList();
    return tasks.where((t) => t['status'] == 'done').toList();
  }

  List<Map<String, dynamic>> get filteredExpenses {
    final idx = expenseFilterIndex.value;
    if (idx == 0)
      return expenses.where((e) => e['status'] == 'pending').toList();
    return expenses;
  }

  void changeMainTab(int index) => mainTabIndex.value = index;

  void changeTaskFilter(int index) => taskFilterIndex.value = index;

  void changeExpenseFilter(int index) => expenseFilterIndex.value = index;

  void addTask(Map<String, dynamic> newTask) {
    tasks.add(newTask);
  }

  void acceptExpense(Map<String, dynamic> expense) {
    final index = expenses.indexOf(expense);
    if (index != -1) {
      expenses[index]['status'] = 'approved';
      expenses.refresh();
    }
  }

  void rejectExpense(Map<String, dynamic> expense) {
    expenses.remove(expense);
  }
}
