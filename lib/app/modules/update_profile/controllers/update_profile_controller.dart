import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UpdateProfileController extends GetxController {
  final namaController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();

  final isFormValid = false.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    namaController.addListener(_validateForm);
    numberController.addListener(_validateForm);
    emailController.addListener(_validateForm);
  }

  void _loadUserData() {
    namaController.text = box.read('nama') ?? '';
    numberController.text = box.read('nomor') ?? '';
    emailController.text = box.read('email') ?? '';
  }

  void _validateForm() {
    isFormValid.value =
        namaController.text.isNotEmpty &&
        numberController.text.isNotEmpty &&
        emailController.text.isNotEmpty;
  }

  void register() {
    try {
      box.write('nama', namaController.text.trim());
      box.write('nomor', numberController.text.trim());
      box.write('email', emailController.text.trim());

      Get.back(result: true);
      Get.snackbar(
        'Berhasil',
        'Data berhasil disimpan secara lokal',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan data: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  void onClose() {
    namaController.dispose();
    numberController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
