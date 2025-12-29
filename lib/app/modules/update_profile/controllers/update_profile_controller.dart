import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../service/auth_service.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../project/controllers/project_controller.dart';
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

    // Gunakan debounce agar validasi tidak jalan terlalu sering saat mengetik cepat
    namaController.addListener(_validateForm);
    numberController.addListener(_validateForm);
    emailController.addListener(_validateForm);
  }

  void _loadUserData() async {
    try {
      String? userId = box.read('userId');
      String? token = await _storageService
          .getToken(); // Konsisten pakai StorageService

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
      debugPrint("Error loading user data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _validateForm() {
    // Validasi sederhana: Tidak kosong & format email benar
    bool isEmailValid = GetUtils.isEmail(emailController.text.trim());

    isFormValid.value =
        namaController.text.trim().isNotEmpty &&
        numberController.text.trim().length >= 3 &&
        isEmailValid;
  }

  Future<void> updateProfile() async {
    if (!isFormValid.value) return;

    try {
      String? userId = box.read('userId');
      String? token = await _storageService.getToken();

      if (userId == null || token == null) {
        _showSnackbar('Sesi Berakhir', 'Silakan login ulang.', isError: true);
        return;
      }

      isLoading.value = true;
      FocusManager.instance.primaryFocus?.unfocus();

      Map<String, dynamic> updateData = {
        "name": namaController.text.trim(),
        "phoneNumber": numberController.text.trim(),
        "email": emailController.text.trim(),
      };

      final response = await _authService.updateUser(userId, token, updateData);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Ambil data terbaru hasil update dari backend
        final updatedUser = responseData['data'];

        // SINKRONISASI: Update data di Controller lain secara sistematis
        _syncControllers(updatedUser);

        Get.back(); // Kembali ke halaman profil setelah sukses

        _showSnackbar('Berhasil', 'Profil Anda telah diperbarui');
      } else {
        _showSnackbar(
          'Gagal',
          responseData['message'] ?? 'Gagal memperbarui data',
          isError: true,
        );
      }
    } catch (e) {
      _showSnackbar('Error', 'Terjadi kesalahan koneksi', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi helper untuk sinkronisasi state di controller lain
  void _syncControllers(Map<String, dynamic> updatedData) {
    // Update ProfileController jika ada
    if (Get.isRegistered<ProfileController>()) {
      final profileCtrl = Get.find<ProfileController>();
      profileCtrl.name.value = updatedData['name'] ?? '';
      profileCtrl.email.value = updatedData['email'] ?? '';
      // Jika ada field lain seperti phoneNumber di ProfileController, update juga di sini
    }

    // Update DashboardController jika ada
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().fetchUserProfile();
    }
    
    // Update ProjectController jika ada
    if (Get.isRegistered<ProjectController>()) {
      Get.find<ProjectController>().fetchUserProfile();
    }
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    // Pastikan context tersedia
    if (Get.context == null) return;

    // Hapus snackbar yang mungkin masih muncul sebelumnya agar tidak menumpuk
    ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(
          "$title: $message",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
