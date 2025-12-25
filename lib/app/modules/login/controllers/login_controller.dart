import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../service/auth_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final box = GetStorage();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var rememberMe = false.obs;

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar("Error", "Please fill all fields", isError: true);
      return;
    }

    try {
      isLoading.value = true;
      final response = await _authService.login(email, password);

      if (response.body == null || response.body.isEmpty)
        throw "No response from server";
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        box.write('token', data['token']);
        box.write('role', data['role']);
        box.write('userId', data['id']);

        _showSnackbar("Success", "Welcome back!");

        await Future.delayed(const Duration(milliseconds: 1000));

        FocusManager.instance.primaryFocus?.unfocus();

        Get.offAllNamed("/home");
      } else {
        _showSnackbar(
          "Login Failed",
          data['message'] ?? "Invalid credentials",
          isError: true,
        );
      }
    } catch (e) {
      _showSnackbar("Error", "Connection failed: $e", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        final response = await _authService.googleLogin(idToken);
        final data = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          box.write('token', data['token']);
          box.write('role', data['role']);
          _showSnackbar("Success", "Login Google Berhasil!");

          await Future.delayed(const Duration(milliseconds: 1000));
          Get.offAllNamed("/home");
        } else {
          _showSnackbar(
            "Error",
            data['message'] ?? "Google Login failed",
            isError: true,
          );
        }
      }
    } catch (error) {
      _showSnackbar("Error", "Google login failed", isError: true);
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

  void toggleRememberMe(bool? value) => rememberMe.value = value ?? false;
  void signUp() => Get.toNamed("/register");
  void forgotPassword() => Get.toNamed('/forget-password');

  @override
  void onClose() {
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }
}
