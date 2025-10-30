import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  var rememberMe = false.obs;

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void login() {
    final name = fullNameController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    Get.snackbar(
      "Success",
      "Logged in as $name",
      snackPosition: SnackPosition.TOP,
    );

    Get.toNamed("/home");
  }

  void signUp() {
    Get.toNamed("/register");
  }

  void forgotPassword() {
    Get.toNamed('/forget-password');
  }
}
