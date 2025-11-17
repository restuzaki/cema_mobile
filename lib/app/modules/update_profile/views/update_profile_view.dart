import 'package:cema_mobile/app/modules/update_profile/controllers/update_profile_controller.dart';

import 'package:cema_mobile/app/widgets/custom_leading_back_action.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class UpdateProfilePage extends GetView<UpdateProfileController> {
  const UpdateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const CustomLeadingBackActionButton(),
        title: const Text('Perbarui Data Pribadi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Silahkan perbarui data anda, guna mempermudah kami untuk memberikan layanan yang lebih baik.',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            CustomFormField(
              controller: controller.namaController,
              typeController: TextInputType.name,
              errorMessage: 'Silahkan lengkapi nama terlebih dahulu!',
              hintText: 'Silahkan isi dengan nama anda!',
              labelText: 'Nama',
            ),
            const SizedBox(height: 10),
            CustomFormField(
              controller: controller.numberController,
              typeController: TextInputType.phone,
              errorMessage: 'Silahkan lengkapi nomor hp terlebih dahulu!',
              hintText: 'Silahkan isi dengan nomor hp anda!',
              labelText: 'Nomor hp',
            ),
            const SizedBox(height: 10),
            CustomFormField(
              controller: controller.emailController,
              typeController: TextInputType.emailAddress,
              errorMessage: 'Silahkan lengkapi email terlebih dahulu!',
              hintText: 'Silahkan isi dengan email anda!',
              labelText: 'Email',
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 15),
            Obx(
              () => CustomButton(
                onTap: controller.isFormValid.value
                    ? controller.register
                    : null,
                isEnabled: controller.isFormValid.value,
                text: 'Perbarui',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
