import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileController extends GetxController {
  var nama = ''.obs;
  var email = ''.obs;
  var photoUrl = ''.obs;
  var isLoading = false.obs;

  final RxString base64Photo = ''.obs;
  final ImagePicker _picker = ImagePicker();
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      nama.value = box.read('nama') ?? 'User Default';
      email.value = box.read('email') ?? 'user@example.com';
      photoUrl.value = box.read('photoUrl') ?? '';
    } catch (e) {
      print('Error fetching profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await box.erase();
    Get.offAllNamed('/login');
    Get.snackbar("Berhasil", "Anda telah logout");
  }

  Future<void> pickImage() async {
    try {
      if (await Permission.photos.isDenied) {
        await Permission.photos.request();
      }

      if (await Permission.photos.isDenied) {
        Get.snackbar(
          "Izin ditolak",
          "Beri izin untuk mengakses galeri terlebih dahulu",
        );
        return;
      }

      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      Uint8List imageBytes = await image.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      await box.write('photoUrl', base64Image);
      photoUrl.value = base64Image;

      Get.snackbar("Berhasil", "Gambar berhasil disimpan dan diperbarui");
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan gambar: $e");
    }
  }

  Future<void> toEditProfilePage() async {
    var result = await Get.toNamed('/update-profile');
    if (result == true) {
      await fetchProfile();
    }
  }
}
