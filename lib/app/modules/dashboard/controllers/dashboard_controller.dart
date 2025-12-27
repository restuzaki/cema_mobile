import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/model/risk.dart';
import '../../../service/auth_service.dart';
import '../../../service/storage_service.dart';

class DashboardController extends GetxController {
  final AuthService _authService = AuthService();
  final box = GetStorage();
  final StorageService _storageService = StorageService();

  var userName = "Loading...".obs;
  var userRole = "Guest".obs;
  var profilePic = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void fetchUserProfile() async {
    try {
      String? userId = box.read('userId');
      String? token = await _storageService.getToken();

      if (userId != null && token != null) {
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

  final RxList<Project> allProjects = <Project>[
    Project(
      id: 'P001',
      name: 'Project Alpha',
      phase: 'Design',
      cpi: 0.91,
      spi: 1.1,
      riskType: RiskType.berisiko,
    ),
    Project(
      id: 'P002',
      name: 'Project Beta',
      phase: 'Development',
      cpi: 0.8,
      spi: 1.1,
      riskType: RiskType.darurat,
    ),
    Project(
      id: 'P003',
      name: 'Project Gamma',
      phase: 'Testing',
      cpi: 1.05,
      spi: 0.95,
      riskType: RiskType.normal,
    ),
    Project(
      id: 'P004',
      name: 'Project Delta',
      phase: 'Deployment',
      cpi: 0.75,
      spi: 0.8,
      riskType: RiskType.darurat,
    ),
    Project(
      id: 'P005',
      name: 'Project Epsilon',
      phase: 'Maintenance',
      cpi: 0.98,
      spi: 1.02,
      riskType: RiskType.berisiko,
    ),
  ].obs;

  List<Project> get filteredProjects {
    switch (selectedRiskTabIndex.value) {
      case 1:
        return allProjects
            .where((p) => p.riskType == RiskType.darurat)
            .toList();
      case 2:
        return allProjects
            .where((p) => p.riskType == RiskType.berisiko)
            .toList();
      case 0:
      default:
        return allProjects;
    }
  }
}
