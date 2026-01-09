import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../service/auth_service.dart';
import '../../../service/storage_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final box = GetStorage();
  final StorageService _storageService = StorageService();

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
      debugPrint("Response: ${response.body}");

      if (response.statusCode == 200 && data['status'] == 'success') {
        // Save token securely
        await _storageService.saveToken(data['data']['token']);
        debugPrint("Token saved successfully ${data['data']['token']}");

        // Save other non-sensitive data
        box.write('userId', data['data']['user']['_id']);
        box.write('name', data['data']['user']['name']);
        box.write('role', data['data']['user']['role']);
        box.write('profilePic', data['data']['user']['profilePicture']);

        debugPrint("Role saved successfully ${data['data']['user']['role']}");
        debugPrint("User ID saved successfully ${data['data']['user']['_id']}");

        _showSnackbar("Success", "Welcome back!");

        // Update FCM token if it differs
        await _updateFcmTokenIfNeeded(
          data['data']['user']['_id'],
          data['data']['token'],
        );

        await Future.delayed(const Duration(milliseconds: 1000));
        FocusManager.instance.primaryFocus?.unfocus();
        Get.offAllNamed("/home");
      } else {
        _showSnackbar(
          "Login Failed",
          data['message'] ??
              data['error'] ??
              "Akun tidak ditemukan atau password salah",
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

        if (response.statusCode == 200 && data['status'] == 'success') {
          // Save token securely
          await _storageService.saveToken(data['token']);

          box.write('role', data['role']);
          box.write('userId', data['id']);

          _showSnackbar("Success", "Login Google Berhasil!");

          // Update FCM token if it differs
          await _updateFcmTokenIfNeeded(data['id'], data['token']);

          await Future.delayed(const Duration(milliseconds: 1000));
          Get.offAllNamed("/home");
        } else {
          _showSnackbar(
            "Akses Ditolak",
            data['message'] ??
                data['error'] ??
                "Akun Google Anda tidak terdaftar di database.",
            isError: true,
          );
        }
      }
    } catch (error) {
      _showSnackbar("Error", "Google login failed: $error", isError: true);
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

  /// Updates FCM token on the backend if it differs from the current one
  Future<void> _updateFcmTokenIfNeeded(String userId, String token) async {
    try {
      // Get current FCM token
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken == null) {
        debugPrint("FCM token is null, skipping update");
        return;
      }

      debugPrint("Current FCM Token: $fcmToken");

      // Get user profile to check current stored FCM token
      final profileResponse = await _authService.getUserProfile(userId, token);

      if (profileResponse.statusCode == 200) {
        final profileData = jsonDecode(profileResponse.body);
        final storedFcmToken = profileData['data']?['fcm_token'];

        debugPrint("Stored FCM Token: $storedFcmToken");

        // Only update if tokens differ
        if (storedFcmToken != fcmToken) {
          debugPrint("FCM tokens differ, updating...");

          final updateResponse = await _authService.updateUser(userId, token, {
            'fcm_token': fcmToken,
          });

          if (updateResponse.statusCode == 200) {
            debugPrint("FCM token updated successfully ${updateResponse.body}");
          } else {
            debugPrint("Failed to update FCM token: ${updateResponse.body}");
          }
        } else {
          debugPrint("FCM token unchanged, no update needed");
        }
      } else {
        debugPrint("Failed to get user profile: ${profileResponse.body}");
      }
    } catch (e) {
      debugPrint("Error updating FCM token: $e");
      // Don't throw error, just log it - we don't want to block login
    }
  }

  @override
  void onClose() {
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }
}
