import 'package:cema_mobile/app/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPageController extends GetxController {
  final emailController = TextEditingController();

  void sendPasswordResetEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Email tidak boleh kosong");
      return;
    }

    try {
      // await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Get.defaultDialog(
        title: '',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/email.png', height: 100),
            const SizedBox(height: 20),
            const Text(
              'Cek Email Anda',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Kami telah mengirimkan tautan untuk menyetel ulang kata sandi ke email Anda. Tautan ini berlaku selama 24 jam.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButton(onTap: () => Get.toNamed('/login'), text: "Cek Email"),
          ],
        ),
        radius: 10,
      );
      // } on FirebaseAuthException catch (e) {
      // Get.snackbar("Gagal", e.message ?? "Terjadi kesalahan");
    } catch (e) {
      Get.snackbar("Gagal", "Terjadi kesalahan yang tidak terduga");
    }
  }
}
