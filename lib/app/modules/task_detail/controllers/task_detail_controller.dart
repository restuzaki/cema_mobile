import 'package:get/get.dart';

class TaskDetailController extends GetxController {
  var currentProjectIndex = 0.obs;
  var isBudgetVisible = true.obs;

  final List<Map<String, dynamic>> task = [
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
  ];

  void changeProject(int index) {
    currentProjectIndex.value = index;
  }

  void toggleBudgetVisibility() {
    isBudgetVisible.value = !isBudgetVisible.value;
  }
}