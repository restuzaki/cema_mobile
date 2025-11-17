import 'package:cema_mobile/app/modules/project_detail/controller/project_detail_controller.dart';
import 'package:get/get.dart';

class ProjectDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectDetailController>(() => ProjectDetailController());
  }
}
