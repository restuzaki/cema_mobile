import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../service/auth_service.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class UpdateProfileController extends GetxController {
  final AuthService _authService = AuthService();
  final box = GetStorage();

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

  void _loadUserData() async {
    // Priority: Fetch from API to ensure fresh data
    try {
      String? userId = box.read('userId');
      String? token = box.read('token');

      if (userId != null && token != null) {
        isLoading.value = true;
        final response = await _authService.getUserProfile(userId, token);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body)['data'];
          namaController.text = data['name'] ?? '';
          numberController.text = data['phoneNumber'] ?? '';
          emailController.text = data['email'] ?? '';
          _validateForm();
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _validateForm() {
    isFormValid.value =
        namaController.text.trim().isNotEmpty &&
        numberController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty;
  }

  Future<void> updateProfile() async {
    try {
      String? userId = box.read('userId');
      String? token = box.read('token');

      if (userId == null || token == null) return;

      isLoading.value = true;
      FocusManager.instance.primaryFocus?.unfocus();

      Map<String, dynamic> updateData = {
        "name": namaController.text.trim(),
        "phoneNumber": numberController.text.trim(),
        "email": emailController.text.trim(),
      };

      print("Sending update data: $updateData");
      final response = await _authService.updateUser(userId, token, updateData);
      print("Update response code: ${response.statusCode}");
      print("Update response body: ${response.body}");

      if (response.statusCode == 200) {
        // Removed box.write as requested - rely on API/Memory state

        if (Get.isRegistered<ProfileController>()) {
          final profileCtrl = Get.find<ProfileController>();
          // Optimistic update: Update UI immediately with the data we just sent
          profileCtrl.name.value = namaController.text.trim();
          profileCtrl.email.value = emailController.text.trim();
          // Removed fetchProfile to avoid race condition with stale data
        }

        if (Get.isRegistered<DashboardController>()) {
          final dashboardCtrl = Get.find<DashboardController>();
          // Optimistic update: Update UI immediately
          dashboardCtrl.userName.value = namaController.text.trim();
          // Removed fetchUserProfile to avoid race condition with stale data
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
