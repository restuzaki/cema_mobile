// lib/app/modules/notification/bindings/notification_binding.dart

import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class NotificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationController());
  }
}
