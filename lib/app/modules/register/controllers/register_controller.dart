import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  var rememberMe = false.obs;

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void register() {
    final name = fullNameController.text.trim();
    final password = passwordController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty || password.isEmpty || email.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    Get.snackbar(
      "Success",
      "Register in as $name",
      snackPosition: SnackPosition.TOP,
    );
  }

  void signIn() {
    Get.toNamed("/login");
  }
}
