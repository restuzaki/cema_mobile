import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../core/exceptions/offline_success_exception.dart';
// Note: We use ProjectModel's TaskModel definition which we just updated.

class AddTaskController extends GetxController {
  final TaskRepository taskRepository = Get.find<TaskRepository>();
  final ProjectRepository projectRepository = Get.find<ProjectRepository>();

  // UI Controllers
  final taskNameController = TextEditingController();
  final budgetAllocationController = TextEditingController();

  // Observables
  final RxList<Project> projects = <Project>[].obs;
  final Rx<Project?> selectedProject = Rx<Project?>(null);
  final RxBool isProjectLocked = false.obs;
  final Rx<DateTime?> dueDate = Rx<DateTime?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProjects(); // Load projects first to populate list/check cache
    _handleEntryPoint();
  }

  @override
  void onClose() {
    taskNameController.dispose();
    budgetAllocationController.dispose();
    super.onClose();
  }

  Future<void> _loadProjects() async {
    try {
      final loadedProjects = await projectRepository.getProjects();
      projects.assignAll(loadedProjects);
    } catch (e) {
      // Handle error or just leave empty if offline and no cache
      print("Error loading projects: $e");
    }
  }

  void _handleEntryPoint() {
    // Check if opened from Project Detail (projectId argument passed)
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args.containsKey('projectId')) {
        final String projectId = args['projectId'];
        // Try to find in loaded projects first
        final project = projects.firstWhereOrNull((p) => p.id == projectId);
        if (project != null) {
          selectedProject.value = project;
          isProjectLocked.value = true;
        } else {
          // If not found in list, and we want to allow 'adding task to project X' without it being in general list
          // We might need to fetch it individually or just proceed if we Trust the ID.
          // However, for UI display, we need project info.
          // Assuming getProjects() eventually returns it or we have partial data.
        }
      }
    }
  }

  void selectProject() async {
    if (isProjectLocked.value) return;

    await _showTemporaryProjectPicker();
  }

  Future<void> _showTemporaryProjectPicker() async {
    // Re-fetch or verify projects just in case
    if (projects.isEmpty) await _loadProjects();

    final result = await Get.bottomSheet<Project>(
      Container(
        color: Colors.white,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final p = projects[index];
            return ListTile(
              title: Text(p.name ?? 'Unnamed Project'),
              subtitle: Text(p.clientName ?? '-'),
              onTap: () => Get.back(result: p),
            );
          },
        ),
      ),
    );

    if (result != null) {
      selectedProject.value = result;
    }
  }

  Future<void> selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      dueDate.value = picked;
    }
  }

  void cancelAddTask() {
    Get.back();
  }

  void confirmAddTask() async {
    // Validation
    if (selectedProject.value == null) {
      Get.snackbar('Error', 'Harap pilih proyek terlebih dahulu');
      return;
    }

    if (taskNameController.text.isEmpty) {
      Get.snackbar('Error', 'Nama Task harus diisi');
      return;
    }

    if (dueDate.value == null) {
      Get.snackbar('Error', 'Tenggat waktu harus diisi');
      return;
    }

    // Budget optional, but if inputs are garbage handle it
    num budget = 0;
    if (budgetAllocationController.text.isNotEmpty) {
      // Remove non-digit chars
      String clean = budgetAllocationController.text.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      budget = num.tryParse(clean) ?? 0;
    }

    isLoading.value = true;

    final newTaskMap = {
      'project_id': selectedProject.value!.id,
      'title': taskNameController.text,
      'budget_allocation': budget,
      'due_date': dueDate.value!.toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
      // 'assigned_to': [],
      // 'attachments': [],
    };

    try {
      await taskRepository.createTask(newTaskMap);
      Get.back();
      Get.snackbar('Sukses', 'Task berhasil disimpan (Online)');
    } catch (e) {
      if (e is OfflineSuccessException) {
        Get.back();
        Get.snackbar('Offline', 'Task disimpan ke antrian offline');
      } else {
        Get.snackbar('Error', 'Gagal menyimpan task: $e');
      }
    } finally {
      print(json.encode(newTaskMap));
      isLoading.value = false;
    }
  }
}
