import 'package:cema_mobile/app/modules/cs_support/controllers/cs_support_controller.dart';
import 'package:cema_mobile/app/widgets/custom_button.dart';
import 'package:cema_mobile/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerSupportPage extends GetView<CustomerSupportController> {
  const CustomerSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Customer Support'),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laporkan Bug atau Masukan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            CustomFormField(
              controller: controller.nameController,
              typeController: TextInputType.text,
              errorMessage: controller.nameError.value,
              hintText: 'Masukkan nama Anda',
              labelText: 'Nama',
              icon: Icons.person,
            ),
            Obx(
              () => controller.nameError.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8, top: 4),
                      child: Text(
                        controller.nameError.value,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )
                  : const SizedBox(),
            ),

            const SizedBox(height: 10),

            CustomFormField(
              controller: controller.emailController,
              typeController: TextInputType.emailAddress,
              errorMessage: controller.emailError.value,
              hintText: 'Masukkan email Anda',
              labelText: 'Email',
              icon: Icons.email,
            ),

            Obx(
              () => controller.emailError.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8, top: 4),
                      child: Text(
                        controller.emailError.value,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(height: 10),

            CustomFormField(
              controller: controller.messageController,
              typeController: TextInputType.multiline,
              errorMessage: controller.messageError.value,
              hintText: 'Tuliskan detail bug atau saran Anda',
              labelText: 'Deskripsi Masalah / Saran',
              icon: Icons.bug_report,
              maxLines: 5,
            ),
            Obx(
              () => controller.messageError.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8, top: 4),
                      child: Text(
                        controller.messageError.value,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(height: 20),

            Obx(
              () => Center(
                child: CustomButton(
                  onTap: controller.isFormValid.value
                      ? controller.sendMessage
                      : null,
                  text: 'Kirim Laporan',
                  isEnabled: controller.isFormValid.value,
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Divider(),
            const Text(
              'Riwayat Laporan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Obx(() {
              if (controller.messages.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('Belum ada laporan yang dikirim.'),
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.messages.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade300, width: 2),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.feedback, color: Colors.black),
                      title: Text(msg.message),
                      subtitle: Text(
                        'Oleh: ${msg.name} (${msg.email})\n${msg.createdAt.toLocal()}',
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
