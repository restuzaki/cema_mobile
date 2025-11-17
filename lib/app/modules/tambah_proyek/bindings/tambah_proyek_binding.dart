import 'package:cema_mobile/app/modules/tambah_proyek/controllers/tambah_proyek_controller.dart';
import 'package:get/get.dart';

class TambahProyekBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahProyekController>(() => TambahProyekController());
  }
}
