import 'package:get/get.dart';
import 'package:cema_mobile/app/routes/app_pages.dart';


class TaskManagerController extends GetxController {

  final progress = <Map<String, dynamic>>[
    {
      'title': 'Rumah Kopo',
      'owner': 'Junaedi Berkah Bertaubat',
      'proggress': 50,
    },
    {
      'title': 'Rumah Kopo',
      'owner': 'Junaedi Berkah Bertaubat',
      'proggress': 50,
    },
    {
      'title': 'Rumah Kopo',
      'owner': 'Junaedi Berkah Bertaubat',
      'proggress': 50,
    },
    {
      'title': 'Rumah Kopo',
      'owner': 'Junaedi Berkah Bertaubat',
      'proggress': 50,
    },
    {
      'title': 'Rumah Kopo',
      'owner': 'Junaedi Berkah Bertaubat',
      'proggress': 50,
    },
  ].obs;

 void goToDetail(Map<String, dynamic> proggress) {
    Get.toNamed(Routes.TASKMANAGER, arguments: progress);
  }
}