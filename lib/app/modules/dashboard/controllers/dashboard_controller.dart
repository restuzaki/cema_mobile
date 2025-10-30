import 'package:get/get.dart';

class DashboardController extends GetxController {
  var currentProjectIndex = 0.obs;
  var isBudgetVisible = true.obs;

  final List<Map<String, dynamic>> projects = [
    {
      'title': 'Rumah Kopo Permai',
      'owner': 'Budi Doremi',
      'location': 'Kopo Permai',
      'category': 'Rumah',
      'progress': 50,
      'status': 'On Time',
    },
    {
      'title': 'Rumah Cibiru Indah',
      'owner': 'Siti Nurhaliza',
      'location': 'Cibiru',
      'category': 'Perumahan',
      'progress': 75,
      'status': 'Delayed',
    },
    {
      'title': 'Ruko Bandung Raya',
      'owner': 'Andi Wijaya',
      'location': 'Soekarno Hatta',
      'category': 'Ruko',
      'progress': 30,
      'status': 'On Time',
    },
  ];

  void changeProject(int index) {
    currentProjectIndex.value = index;
  }

  void toggleBudgetVisibility() {
    isBudgetVisible.value = !isBudgetVisible.value;
  }
}
