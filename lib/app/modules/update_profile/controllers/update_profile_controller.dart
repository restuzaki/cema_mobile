import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../service/auth_service.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../../service/storage_service.dart';

class UpdateProfileController extends GetxController {
  final AuthService _authService = AuthService();
  final box = GetStorage();
  final StorageService _storageService = StorageService();

  final namaController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();

  final isFormValid = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    namaController.addListener(_validateForm);
    numberController.addListener(_validateForm);
    emailController.addListener(_validateForm);
  }

  void _loadUserData() {
    namaController.text = box.read('name') ?? '';
    numberController.text = box.read('phoneNumber') ?? '';
    emailController.text = box.read('email') ?? '';
    _validateForm();
  }

  void _validateForm() {
    isFormValid.value =
        namaController.text.trim().isNotEmpty &&
        numberController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty;
  }

  Future<void> updateProfile() async {
    debugPrint("DEBUG: updateProfile called");
    try {
      String? userId = box.read('userId');
      String? token = await _storageService.getToken();

      debugPrint(
        "DEBUG: userId: $userId, token: ${token != null ? 'Found' : 'Null'}",
      );

      if (userId == null || token == null) {
        debugPrint("DEBUG: Credentials missing. Aborting update.");
        _showSnackbar(
          'Session Expired',
          'Silakan login ulang untuk memperbarui sesi.',
          isError: true,
        );
        return;
      }

      isLoading.value = true;
      FocusManager.instance.primaryFocus?.unfocus();

      Map<String, dynamic> updateData = {
        "name": namaController.text.trim(),
        "phoneNumber": numberController.text.trim(),
        "email": emailController.text.trim(),
      };

      debugPrint("DEBUG: Sending update data: $updateData");

      final response = await _authService.updateUser(userId, token, updateData);

      debugPrint("DEBUG: Response: ${response.body}");

      if (response.statusCode == 200) {
        box.write('name', namaController.text.trim());
        box.write('phoneNumber', numberController.text.trim());
        box.write('email', emailController.text.trim());

        if (Get.isRegistered<ProfileController>()) {
          final profileCtrl = Get.find<ProfileController>();
          profileCtrl.fetchProfile();
        }

        if (Get.isRegistered<DashboardController>()) {
          final dashboardCtrl = Get.find<DashboardController>();
          dashboardCtrl.fetchUserProfile();
        }

        _showSnackbar('Berhasil', 'Data pribadi berhasil diperbarui');
      } else {
        final errorData = jsonDecode(response.body);
        _showSnackbar(
          'Gagal',
          errorData['message'] ?? 'Gagal memperbarui data',
          isError: true,
        );
      }
    } catch (e) {
      _showSnackbar('Error', 'Terjadi kesalahan koneksi', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text("$title: $message"),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void onClose() {
    namaController.dispose();
    numberController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
