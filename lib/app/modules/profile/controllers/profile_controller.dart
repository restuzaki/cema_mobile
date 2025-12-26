import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../service/auth_service.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();
  final box = GetStorage();
  final ImagePicker _picker = ImagePicker();

  var name = ''.obs;
  var email = ''.obs;
  var photoUrl = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  // Fungsi ini akan dipanggil oleh UpdateProfileController
  Future<void> fetchProfile() async {
    // isLoading.value = true; // Opsional: aktifkan jika ingin spinner muncul saat refresh
    try {
      String? userId = box.read('userId');
      String? token = box.read('token');

      if (userId != null && token != null) {
        final response = await _authService.getUserProfile(userId, token);
        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body)['data'];

          // Update variabel .obs agar UI langsung berubah
          name.value = userData['name'] ?? '';
          email.value = userData['email'] ?? '';
          photoUrl.value = userData['profilePicture'] ?? '';

          // Sinkronkan ulang data di storage
          box.write('name', name.value);
          box.write('email', email.value);
          box.write('phoneNumber', userData['phoneNumber'] ?? '');
        }
      }
    } catch (e) {
      print('Error fetching profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 30,
        maxWidth: 600,
        maxHeight: 600,
      );

      if (image == null) return;

      isLoading.value = true;
      Uint8List imageBytes = await image.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      String? userId = box.read('userId');
      String? token = box.read('token');

      if (userId != null && token != null) {
        final response = await _authService.updateUser(userId, token, {
          "profilePicture": base64Image,
        });

        if (response.statusCode == 200) {
          photoUrl.value = base64Image;
          box.write('photoUrl', base64Image);
          _safeShowSnackbar("Sukses", "Foto profil berhasil diperbarui");
          
           if (Get.isRegistered<DashboardController>()) {
            Get.find<DashboardController>().fetchUserProfile();
          }
        } else {
          _safeShowSnackbar("Gagal", "Gagal update di server", isError: true);
        }
      }
    } catch (e) {
      _safeShowSnackbar("Error", "Gagal memproses gambar", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void _safeShowSnackbar(String title, String message, {bool isError = false}) {
    // Menggunakan cara ScaffoldMessenger agar konsisten dan aman dari LateInitializationError
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text("$title: $message"),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void logout() async {
    await box.erase();
    Get.offAllNamed('/login');
  }

  Future<void> toEditProfilePage() async {
    var result = await Get.toNamed('/update-profile');
    if (result == true) fetchProfile();
  }
}
