import 'package:get/get.dart';
import '../model/project_model.dart';

class DataController extends GetxController {
  // Observable lists for reactive UI updates
  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxList<TaskModel> allTasks = <TaskModel>[].obs;
  final RxList<ExpenseModel> allExpenses = <ExpenseModel>[].obs;

  // Currently selected project
  final Rx<ProjectModel?> selectedProject = Rx<ProjectModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _initializeDummyData();
  }

  // Initialize with dummy data
  void _initializeDummyData() {
    final project1 = ProjectModel(
      id: 'proj_1',
      name: 'Website Redesign',
      phase: 'Development',
      client: 'PT Maju Jaya',
      status: 'berisiko',
      cpi: 0.91,
      spi: 1.1,
    );

    final project2 = ProjectModel(
      id: 'proj_2',
      name: 'Mobile App',
      phase: 'Testing',
      client: 'CV Digital',
      status: 'darurat',
      cpi: 0.8,
      spi: 1.1,
    );

    projects.addAll([project1, project2]);

    // Add sample tasks
    final tasks = [
      TaskModel(
        id: 'task_1',
        projectId: 'proj_1',
        title: 'Design Homepage',
        responsibleName: 'John Doe',
        description: 'Create new homepage design',
        startDate: DateTime(2025, 11, 10),
        dueDate: DateTime(2025, 11, 18),
        phase: 'Development',
        status: 'ongoing',
      ),
      TaskModel(
        id: 'task_2',
        projectId: 'proj_1',
        title: 'Implement Login',
        responsibleName: 'Jane Smith',
        description: 'Implement user login functionality',
        startDate: DateTime(2025, 11, 15),
        dueDate: DateTime(2025, 11, 20),
        phase: 'Development',
        status: 'ongoing',
      ),
      TaskModel(
        id: 'task_3',
        projectId: 'proj_1',
        title: 'Fix Bug API',
        responsibleName: 'Bob Wilson',
        description: 'Fix authentication bug',
        startDate: DateTime(2025, 11, 5),
        dueDate: DateTime(2025, 11, 10),
        phase: 'Development',
        status: 'late',
      ),
      TaskModel(
        id: 'task_4',
        projectId: 'proj_2',
        title: 'UI Testing',
        responsibleName: 'Alice Brown',
        description: 'Test all UI components',
        startDate: DateTime(2025, 11, 12),
        dueDate: DateTime(2025, 11, 22),
        phase: 'Testing',
        status: 'ongoing',
      ),
    ];

    allTasks.addAll(tasks);

    // Add sample expenses
    final expenses = [
      ExpenseModel(
        id: 'exp_1',
        projectId: 'proj_1',
        amount: 150000000,
        description: 'Server hosting payment',
        status: 'pending',
        createdAt: DateTime(2025, 11, 15),
      ),
      ExpenseModel(
        id: 'exp_2',
        projectId: 'proj_1',
        amount: 150000000,
        description: 'Design software license',
        status: 'approved',
        createdAt: DateTime(2025, 11, 10),
      ),
      ExpenseModel(
        id: 'exp_3',
        projectId: 'proj_2',
        amount: 200000000,
        description: 'Development tools',
        status: 'pending',
        createdAt: DateTime(2025, 11, 17),
      ),
    ];

    allExpenses.addAll(expenses);
  }

  // Get tasks for specific project
  List<TaskModel> getTasksByProject(String projectId) {
    return allTasks.where((task) => task.projectId == projectId).toList();
  }

  // Get expenses for specific project
  List<ExpenseModel> getExpensesByProject(String projectId) {
    return allExpenses
        .where((expense) => expense.projectId == projectId)
        .toList();
  }

  // Add new task
  void addTask(TaskModel task) {
    allTasks.add(task);
  }

  // Update task
  void updateTask(String taskId, TaskModel updatedTask) {
    final index = allTasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      allTasks[index] = updatedTask;
      allTasks.refresh();
    }
  }

  // Delete task
  void deleteTask(String taskId) {
    allTasks.removeWhere((task) => task.id == taskId);
  }

  // Add new expense
  void addExpense(ExpenseModel expense) {
    allExpenses.add(expense);
  }

  // Update expense
  void updateExpense(String expenseId, ExpenseModel updatedExpense) {
    final index = allExpenses.indexWhere((expense) => expense.id == expenseId);
    if (index != -1) {
      allExpenses[index] = updatedExpense;
      allExpenses.refresh();
    }
  }

  // Delete expense
  void deleteExpense(String expenseId) {
    allExpenses.removeWhere((expense) => expense.id == expenseId);
  }

  // Add new project
  void addProject(ProjectModel project) {
    projects.add(project);
  }

  // Update project
  void updateProject(String projectId, ProjectModel updatedProject) {
    final index = projects.indexWhere((project) => project.id == projectId);
    if (index != -1) {
      projects[index] = updatedProject;
      projects.refresh();
    }
  }

  // Select project
  void selectProject(ProjectModel project) {
    selectedProject.value = project;
  }

  // Get project by ID
  ProjectModel? getProjectById(String projectId) {
    try {
      return projects.firstWhere((project) => project.id == projectId);
    } catch (e) {
      return null;
    }
  }

  // Filter projects by status
  List<ProjectModel> getProjectsByStatus(String? status) {
    if (status == null || status == 'all') return projects;
    return projects.where((project) => project.status == status).toList();
  }

  // Filter tasks by status
  List<TaskModel> filterTasksByStatus(String projectId, String? status) {
    final projectTasks = getTasksByProject(projectId);
    if (status == null || status == 'all') return projectTasks;
    return projectTasks.where((task) => task.status == status).toList();
  }

  // Accept expense
  void acceptExpense(String expenseId) {
    final index = allExpenses.indexWhere((expense) => expense.id == expenseId);
    if (index != -1) {
      allExpenses[index] = allExpenses[index].copyWith(status: 'approved');
      allExpenses.refresh();
    }
  }

  // Reject expense
  void rejectExpense(String expenseId) {
    final index = allExpenses.indexWhere((expense) => expense.id == expenseId);
    if (index != -1) {
      allExpenses[index] = allExpenses[index].copyWith(status: 'rejected');
      allExpenses.refresh();
    }
  }
}
