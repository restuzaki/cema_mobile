import 'dart:convert';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/controllers/data_controller.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../service/auth_service.dart';
import '../../../service/authenticated_client.dart';
import '../../../service/storage_service.dart';

class ProjectController extends GetxController {
  // Dependency Injection (could be abstracted further with Bindings)
  final ProjectRepository _repository = ProjectRepository(
    client: AuthenticatedClient(),
  );

  StreamSubscription? _connectivitySubscription;

  final box = GetStorage();
  final AuthService _authService = AuthService();

  final StorageService _storageService = StorageService();

  // Observable Variables
  final RxBool isLoading = false.obs;
  final RxList<Project> projects = <Project>[].obs;
  final RxString errorMessage = ''.obs;

  var userName = "".obs;
  var userRole = "".obs;
  var profilePic = "".obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
    fetchProjects();

    // Listen to network changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      final isOnline = !result.contains(ConnectivityResult.none);

      if (isOnline) {
        // print("Network restored: Syncing...");
        _repository.syncPendingActions().then((_) {
          // Optional: trigger a UI refresh of the list if sync brought new real IDs
          fetchProjects();
        });
      }
    });
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  void getUserData() {
    userName.value = box.read('name');
    userRole.value = box.read('role');
    profilePic.value = box.read('profilePic') ?? "";
  }

  void fetchProjects() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getProjects();
      projects.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
      // Optional: Show snackbar
      // Get.snackbar('Error', 'Failed to fetch projects: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Create a new project (Handles Offline & Online)
  Future<void> createProject(Map<String, dynamic> projectData) async {
    try {
      isLoading.value = true;
      await _repository.createProject(projectData);

      // If success (Online)
      Get.back(); // Close dialog/page
      Get.snackbar("Success", "Project Created!");

      // Refresh list
      fetchProjects();
    } catch (e) {
      if (e is OfflineSuccessException) {
        Get.back();
        Get.snackbar("Offline", e.message);
        // We could manually insert a "fake" project into `projects` here for immediate feedback,
        // but simple list refresh might pick up local cache if we updated it in repo.
        // For now, the prompt expects just the snackbar.
      } else {
        Get.snackbar("Error", "Failed to create project: $e");
      }
    } finally {
      isLoading.value = false;
    }
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

  // UI State
  final RxInt currentTab = 0.obs; // 0: All, 1: Berlangsung, 2: Selesai

  // Computed Properties for Stats
  int get totalProjects => projects.length;

  int get activeProjects => projects.where((p) {
    final s = p.status?.toUpperCase() ?? '';
    return s != 'COMPLETED' && s != 'CANCELLED';
  }).length;

  int get completedProjects =>
      projects.where((p) => p.status?.toUpperCase() == 'COMPLETED').length;

  List<Project> get filteredProjects {
    switch (currentTab.value) {
      case 1: // Berlangsung (Active)
        return projects.where((p) {
          final s = p.status?.toUpperCase() ?? '';
          return s != 'COMPLETED' && s != 'CANCELLED';
        }).toList();
      case 2: // Selesai (Completed)
        return projects
            .where((p) => p.status?.toUpperCase() == 'COMPLETED')
            .toList();
      case 0: // All
      default:
        return projects;
    }
  }

  final DataController _dataController = Get.find<DataController>();

  void changeTab(int index) {
    currentTab.value = index;
  }

  void navigateToDetail(Project project) async {
    _dataController.selectProject(project);
    await Get.toNamed('/project-details', arguments: {'project': project});
    fetchProjects(); // Refresh list on return
  }
}
