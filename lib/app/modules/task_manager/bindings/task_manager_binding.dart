import 'package:cema_mobile/app/modules/task_manager/controllers/task_manager_controller.dart';
import 'package:get/get.dart';

class TaskManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskManagerController>(() => TaskManagerController());
  }
}
