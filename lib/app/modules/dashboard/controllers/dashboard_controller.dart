import 'package:get/get.dart';

import '../../../data/model/risk.dart';

class DashboardController extends GetxController {
  final RxInt selectedRiskTabIndex = 0.obs;

  void changeRiskTab(int index) {
    selectedRiskTabIndex.value = index;
  }

  void acceptTask(String taskId) {
    Get.snackbar("Sukses", "Tugas $taskId diterima");
  }

  void rejectTask(String taskId) {
    Get.snackbar("Info", "Tugas $taskId ditolak");
  }

  void acceptProject(String projectId) {
    Get.snackbar("Sukses", "Proyek $projectId diterima");
  }

  void rejectProject(String projectId) {
    Get.snackbar("Info", "Proyek $projectId ditolak");
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
            .where((project) => project.riskType == RiskType.darurat)
            .toList();
      case 2:
        return allProjects
            .where((project) => project.riskType == RiskType.berisiko)
            .toList();
      case 0:
      default:
        return allProjects;
    }
  }
}
