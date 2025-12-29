import 'package:get/get.dart';
import '../../../data/controllers/data_controller.dart';
import '../../../data/models/project_model.dart';

class TaskManagerController extends GetxController {
  final DataController dataController = Get.find<DataController>();

  var selectedTabIndex = 0.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  List<Project> get filteredProjects {
    if (selectedTabIndex.value == 0) {
      return dataController.projects;
    } else if (selectedTabIndex.value == 1) {
      return dataController.projects
          .where(
            (p) =>
                p.status == 'normal' ||
                p.status == 'berisiko' ||
                p.status == 'darurat',
          )
          .toList();
    } else {
      return dataController.projects
          .where((p) => p.status == 'selesai')
          .toList();
    }
  }

  void goToProjectDetail(Project project) {
    dataController.selectProject(project);
    Get.toNamed('/project-detail');
  }
}
