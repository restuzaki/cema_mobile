import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/controllers/data_controller.dart';
import '../../../data/models/project_model.dart';

class AddTaskController extends GetxController {
  final DataController dataController = Get.find<DataController>();
  // Text controllers
  final responsibleNameController = TextEditingController();
  final taskNameController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  // Observable
  var selectedStatus = 'Menunggu'.obs;
  var isLoading = false.obs;

  final List<String> statusOptions = [
    'Menunggu',
    'Berlangsung',
    'Selesai',
    'Terlambat',
  ];

  @override
  void onInit() {
    super.onInit();
    // Set default dates
    startDateController.text = _formatDate(DateTime.now());
    endDateController.text = _formatDate(
      DateTime.now().add(const Duration(days: 7)),
    );
  }

  @override
  void onClose() {
    responsibleNameController.dispose();
    taskNameController.dispose();
    taskDescriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.onClose();
  }

  void selectStatus(String status) {
    selectedStatus.value = status;
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      startDateController.text = _formatDate(picked);
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      endDateController.text = _formatDate(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void cancelAddTask() {
    Get.back();
  }

  void confirmAddTask() {
    // Validation
    if (responsibleNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama Penanggung Jawab harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (taskNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama Task harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    final currentProject = dataController.selectedProject.value;
    if (currentProject == null) {
      Get.snackbar(
        'Error',
        'Project tidak ditemukan',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    isLoading.value = true;

    // Parse dates
    final startDate = _parseDate(startDateController.text);
    final endDate = _parseDate(endDateController.text);

    // Create new task
    final newTask = TaskModel(
      id: 'task_${DateTime.now().millisecondsSinceEpoch}',
      projectId: currentProject.id,
      title: taskNameController.text,
      responsibleName: responsibleNameController.text,
      description: taskDescriptionController.text,
      startDate: startDate,
      dueDate: endDate,
      phase: currentProject.phase,
      status: _mapStatusToInternal(selectedStatus.value),
    );

    // Add to data controller
    dataController.addTask(newTask);

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.back();
      Get.snackbar(
        'Sukses',
        'Task berhasil ditambahkan',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    });
  }

  DateTime _parseDate(String dateString) {
    try {
      final parts = dateString.split('/');
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (e) {
      return DateTime.now();
    }
  }

  String _mapStatusToInternal(String displayStatus) {
    switch (displayStatus) {
      case 'Menunggu':
        return 'menunggu';
      case 'Berlangsung':
        return 'ongoing';
      case 'Selesai':
        return 'done';
      case 'Terlambat':
        return 'late';
      default:
        return 'ongoing';
    }
  }
}
