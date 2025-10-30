import 'package:cema_mobile/app/modules/forget_password/controllers/forget_password_controller.dart';
import 'package:get/get.dart';

class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgetPasswordPageController>(
      () => ForgetPasswordPageController(),
    );
  }
}
