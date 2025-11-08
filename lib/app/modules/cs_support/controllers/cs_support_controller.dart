import 'package:cema_mobile/app/data/model/support_messege.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CustomerSupportController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  final isFormValid = false.obs;
  final messages = <SupportMessage>[].obs;

  final nameError = RxString('');
  final emailError = RxString('');
  final messageError = RxString('');

  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadMessages();

    nameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    messageController.addListener(_validateForm);
  }

  void _validateForm() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final message = messageController.text.trim();

    nameError.value = name.isEmpty ? 'Nama tidak boleh kosong' : '';
    emailError.value = _validateEmail(email);
    messageError.value = message.isEmpty
        ? 'Deskripsi masalah atau saran harus diisi'
        : '';

    isFormValid.value =
        nameError.value.isEmpty &&
        emailError.value.isEmpty &&
        messageError.value.isEmpty;
  }

  String _validateEmail(String email) {
    if (email.isEmpty) return 'Email tidak boleh kosong';
    if (!email.isEmail) return 'Format email tidak valid';
    return '';
  }

  void loadMessages() {
    final savedData = storage.read<List>('supportMessages') ?? [];
    messages.assignAll(
      savedData.map(
        (e) => SupportMessage.fromJson(Map<String, dynamic>.from(e)),
      ),
    );
  }

  void sendMessage() {
    final newMessage = SupportMessage(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      message: messageController.text.trim(),
      createdAt: DateTime.now(),
    );

    messages.add(newMessage);
    storage.write('supportMessages', messages.map((e) => e.toJson()).toList());

    clearForm();

    Get.snackbar('Berhasil', 'Laporan kamu telah dikirim!');
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    messageController.clear();
    nameError.value = '';
    emailError.value = '';
    messageError.value = '';
    _validateForm();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
