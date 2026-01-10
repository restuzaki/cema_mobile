import 'dart:convert';
import 'package:cema_mobile/app/data/repositories/project_repository.dart';
import 'package:cema_mobile/app/data/repositories/task_repository.dart';
import 'package:cema_mobile/app/data/repositories/expense_repository.dart';
import 'package:cema_mobile/app/data/models/task_model.dart';
import 'package:cema_mobile/app/data/models/expense_model.dart';
import 'package:cema_mobile/app/service/authenticated_client.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/project_model.dart';
import '../../../service/auth_service.dart';
import '../../../service/storage_service.dart';

class DashboardController extends GetxController {
  final AuthService _authService = AuthService();
  final ProjectRepository _projectRepository = ProjectRepository(
    client: AuthenticatedClient(),
  );
  final TaskRepository _taskRepository = TaskRepository(
    client: AuthenticatedClient(),
  );
  final ExpenseRepository _expenseRepository = ExpenseRepository(
    client: AuthenticatedClient(),
  );
  final box = GetStorage();
  final StorageService _storageService = StorageService();

  final RxList<Project> allProjects = <Project>[].obs;
  final RxList<Task> upcomingTasks = <Task>[].obs;
  final RxList<Expense> pendingExpenses = <Expense>[].obs;

  var userName = "".obs;
  var userRole = "".obs;
  var profilePic = "".obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
    fetchProjects();
    fetchUpcomingTasks();
    fetchPendingExpenses();
  }

  void getUserData() {
    userName.value = box.read('name');
    userRole.value = box.read('role');
    profilePic.value = box.read('profilePic') ?? "";
  }

  void fetchUserProfile() async {
    try {
      String? userId = box.read('userId');
      String? token = await _storageService.getToken();

      if (userId != null && token != null) {
        isLoading.value = true;
        final response = await _authService.getUserProfile(userId, token);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final userData = responseData['data'];

          userName.value = userData['name'] ?? "No Name";

          String rawRole = userData['role'] ?? "client";
          userRole.value = rawRole
              .replaceAll('_', ' ')
              .split(' ')
              .map((str) => str.capitalize)
              .join(' ');

          profilePic.value = userData['profilePicture'] ?? "";
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  final RxInt selectedRiskTabIndex = 0.obs;
  final RxBool isFabMenuOpen = false.obs;

  void changeRiskTab(int index) {
    selectedRiskTabIndex.value = index;
  }

  void toggleFabMenu() {
    isFabMenuOpen.toggle();
  }

  void acceptTask(String taskId) {
    Get.snackbar("Sukses", "Tugas $taskId diterima");
  }

  void rejectTask(String taskId) {
    Get.snackbar("Info", "Tugas $taskId ditolak");
  }

  List<Project> get filteredProjects {
    switch (selectedRiskTabIndex.value) {
      case 1:
      // return allProjects
      // .where((p) => p.riskType == RiskType.darurat)
      // .toList();
      case 2:
      // return allProjects
      // .where((p) => p.riskType == RiskType.berisiko)
      // .toList();
      case 0:
      default:
        return allProjects;
    }
  }

  List<Project> get limitedFilteredProjects {
    final filtered = filteredProjects;
    return filtered.length > 3 ? filtered.take(3).toList() : filtered;
  }

  bool get hasMoreProjects => filteredProjects.length > 3;

  void navigateToDetail(Project project) async {
    await Get.toNamed('/project-details', arguments: {'project': project});
    fetchProjects(); // Refresh list on return
  }

  void fetchProjects() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _projectRepository.getProjects();
      allProjects.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to fetch projects: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void fetchUpcomingTasks() async {
    try {
      final tasks = await _taskRepository.getUpcomingTasks();
      // Only show top 3 tasks
      upcomingTasks.value = tasks.take(3).toList();
    } catch (e) {
      print('Error fetching upcoming tasks: $e');
      upcomingTasks.value = [];
    }
  }

  void fetchPendingExpenses() async {
    try {
      final expenses = await _expenseRepository.getPendingExpenses();
      // Only show top 3 expenses
      pendingExpenses.value = expenses.take(3).toList();
    } catch (e) {
      print('Error fetching pending expenses: $e');
      pendingExpenses.value = [];
    }
  }
}
