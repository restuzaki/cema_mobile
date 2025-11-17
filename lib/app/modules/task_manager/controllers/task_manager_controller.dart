import 'package:get/get.dart';
import 'package:cema_mobile/app/routes/app_pages.dart';


class TaskManagerController extends GetxController {

 void goToDetail(Map<String, dynamic> proggress) {
    Get.toNamed(Routes.TASKMANAGER);
  }
}