import 'package:cema_mobile/app/data/controllers/data_controller.dart';
import 'package:cema_mobile/app/modules/project_detail/controller/project_detail_controller.dart';
import 'package:cema_mobile/app/modules/task_manager/controllers/task_manager_controller.dart';
import 'package:get/get.dart';

import '../../dashboard/controllers/dashboard_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize DataController first (as singleton)
    Get.put(DataController(), permanent: true);

    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<TaskManagerController>(() => TaskManagerController());
    Get.lazyPut<ProjectDetailController>(() => ProjectDetailController());
  }
}
