import 'package:cema_mobile/app/modules/forget_password/controllers/forget_password_controller.dart';
import 'package:cema_mobile/app/widgets/custom_button.dart';
import 'package:cema_mobile/app/widgets/custom_leading_back_action.dart';
import 'package:cema_mobile/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordPage extends GetView<ForgetPasswordPageController> {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: CustomLeadingBackActionButton(),
        title: const Text('Lupa Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Link reset password akan dikirim melalui email.\nEmail harus aktif dan sesuai dengan yang terdaftar.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),
            CustomFormField(
              controller: controller.emailController,
              typeController: TextInputType.emailAddress,
              errorMessage: 'Silahkan lengkapi email terlebih dahulu!',
              hintText: 'Silahkan isi dengan email anda!',
              labelText: 'Email',
            ),
            const SizedBox(height: 20),
            Center(
              child: CustomButton(
                onTap: () => controller.sendPasswordResetEmail(),
                text: 'Kirim',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
