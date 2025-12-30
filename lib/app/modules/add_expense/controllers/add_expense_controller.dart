import 'package:cema_mobile/app/service/authenticated_client.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/expense_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../core/exceptions/offline_success_exception.dart';

class AddExpenseController extends GetxController {
  final ProjectRepository projectRepository = ProjectRepository(
    client: AuthenticatedClient(),
  );
  final ExpenseRepository expenseRepository = ExpenseRepository(
    client: AuthenticatedClient(),
  );
  final GetStorage box = GetStorage();

  // UI Controllers
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  // Observables
  final RxList<Project> projects = <Project>[].obs;
  final Rx<Project?> selectedProject = Rx<Project?>(null);
  final RxBool isProjectLocked = false.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxString selectedCategory = ''.obs;
  final RxBool isLoading = false.obs;

  final List<String> categories = [
    'TRANSPORTATION',
    'MATERIAL',
    'MEAL',
    'OTHER',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadProjects();
    _handleEntryPoint();
  }

  @override
  void onClose() {
    titleController.dispose();
    amountController.dispose();
    super.onClose();
  }

  Future<void> _loadProjects() async {
    try {
      final loadedProjects = await projectRepository.getProjects();
      projects.assignAll(loadedProjects);
    } catch (e) {
      print("Error loading projects: $e");
    }
  }

  void _handleEntryPoint() {
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args.containsKey('projectId')) {
        final String projectId = args['projectId'];
        final project = projects.firstWhereOrNull((p) => p.id == projectId);
        if (project != null) {
          selectedProject.value = project;
          isProjectLocked.value = true;
        }
      }
    }
  }

  void selectProject() async {
    if (isProjectLocked.value) return;

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

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void cancel() {
    Get.back();
  }

  void submit() async {
    // Validation
    if (selectedProject.value == null) {
      Get.snackbar(
        'Error',
        'Harap pilih proyek terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (titleController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Judul pengeluaran harus diisi',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (amountController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Jumlah harus diisi',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedDate.value == null) {
      Get.snackbar(
        'Error',
        'Tanggal harus diisi',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedCategory.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Kategori harus dipilih',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Prepare Data
    num amount = 0;
    String cleanAmount = amountController.text.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
    amount = num.tryParse(cleanAmount) ?? 0;

    final userId = box.read('userId');
    // Note: Backend documentation says project manager id is taken from project,
    // user_id from box is good.
    // However, the PAYLOAD structure in BACKEND.MD does not ask for manager_id or user_id in the request body.
    // It says "manager_id" and "user_id" are in the RESPONSE/DATA.
    // The backend likely infers these from the Auth Token and Project Data.
    // So we just send what BACKEND.MD asks for: project_id, title, amount, currency, category, date.

    final expenseData = {
      'project_id': selectedProject.value!.id,
      'title': titleController.text,
      'amount': amount,
      'currency':
          'IDR', // Defaulting to IDR for now as per "Multi-currency Support" but usually UI defaults to one
      'category': selectedCategory.value,
      'date': selectedDate.value!.toIso8601String(),
    };

    isLoading.value = true;

    try {
      await expenseRepository.createExpense(expenseData);
      Get.back();
      Get.snackbar(
        'Sukses',
        'Pengeluaran berhasil disimpan (Online)',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      if (e is OfflineSuccessException) {
        Get.back();
        Get.snackbar(
          'Offline',
          'Pengeluaran disimpan ke antrian offline',
          backgroundColor: Colors.amber,
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Gagal menyimpan pengeluaran: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
