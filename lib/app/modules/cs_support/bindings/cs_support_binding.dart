import 'package:cema_mobile/app/modules/cs_support/controllers/cs_support_controller.dart';

import 'package:get/get.dart';

class CsSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerSupportController>(() => CustomerSupportController());
  }
}
