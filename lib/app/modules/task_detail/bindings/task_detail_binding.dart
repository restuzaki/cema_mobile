import 'package:cema_mobile/app/modules/task_detail/controllers/task_detail_controller.dart';
import 'package:get/get.dart';

class TaskDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskDetailController>(() => TaskDetailController());
  }
}
