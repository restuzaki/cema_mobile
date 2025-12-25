import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../service/auth_service.dart';

class RegisterController extends GetxController {
  final AuthService _authService = AuthService();
  final box = GetStorage();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  void register() async {
    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackbar("Error", "Please fill all fields", isError: true);
      return;
    }

    try {
      isLoading.value = true;

      FocusManager.instance.primaryFocus?.unfocus();

      final response = await _authService.register(name, email, password);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackbar("Success", "Account created successfully!");

        await Future.delayed(const Duration(seconds: 1));

        Get.offAllNamed("/login");
      } else {
        _showSnackbar(
          "Failed",
          data['message'] ?? "Registration failed",
          isError: true,
        );
      }
    } catch (e) {
      _showSnackbar("Error", "Check your connection", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void signIn() => Get.toNamed("/login");

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
