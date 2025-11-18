import 'package:get/get.dart';

class TaskManagerController extends GetxController {
  var selectedTabIndex = 0.obs;

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void goToProjectDetail() {
    // Navigate to project detail
    Get.toNamed('/project-detail');
  }
}
