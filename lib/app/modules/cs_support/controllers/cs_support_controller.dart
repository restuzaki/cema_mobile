import 'package:cema_mobile/app/data/model/support_messege.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerSupportController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  final isLoading = false.obs;
  final isFormValid = false.obs;
  final messages = <SupportMessage>[].obs;

  final emailError = RxString('');
  final nameError = RxString('');

  final captchaToken = ''.obs;

  final storage = GetStorage();
  final String _baseUrl = dotenv.env['API_KEY'] ?? '';

  @override
  void onInit() {
    super.onInit();
    loadMessages();

    firstNameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    subjectController.addListener(_validateForm);
    messageController.addListener(_validateForm);
  }

  void _validateForm() {
    final email = emailController.text.trim();
    emailError.value = GetUtils.isEmail(email)
        ? ''
        : 'Format email tidak valid';
    nameError.value = firstNameController.text.isEmpty
        ? 'Nama depan wajib diisi'
        : '';

    isFormValid.value =
        firstNameController.text.isNotEmpty &&
        GetUtils.isEmail(email) &&
        subjectController.text.isNotEmpty &&
        messageController.text.isNotEmpty;
  }

  void loadMessages() {
    final savedData = storage.read<List>('supportMessages') ?? [];
    messages.assignAll(
      savedData.map(
        (e) => SupportMessage.fromJson(Map<String, dynamic>.from(e)),
      ),
    );
  }

  void _showCustomSnackBar(String message, {bool isError = false}) {
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> sendMessage() async {
    if (!isFormValid.value) {
      _showCustomSnackBar(
        "Mohon lengkapi formulir dengan benar",
        isError: true,
      );
      return;
    }

    if (captchaToken.value.isEmpty) {
      _showCustomSnackBar(
        "Silakan verifikasi bahwa Anda bukan robot",
        isError: true,
      );
      return;
    }

    isLoading.value = true;

    try {
      final url = Uri.parse('$_baseUrl/contact');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "firstName": firstNameController.text.trim(),
          "lastName": lastNameController.text.trim(),
          "email": emailController.text.trim(),
          "phoneNumber": phoneController.text.trim(),
          "subject": subjectController.text.trim(),
          "message": messageController.text.trim(),
          "captchaToken": captchaToken.value,
        }),
      );

      if (response.statusCode == 200) {
        final newMessage = SupportMessage(
          name: "${firstNameController.text} ${lastNameController.text}",
          email: emailController.text.trim(),
          subject: subjectController.text.trim(),
          message: messageController.text.trim(),
          createdAt: DateTime.now(),
        );
        messages.insert(0, newMessage);
        await storage.write(
          'supportMessages',
          messages.map((e) => e.toJson()).toList(),
        );

        clearForm();
        _showCustomSnackBar("Pesan Anda telah berhasil terkirim!");
      } else {
        throw Exception(
          "Gagal menghubungi server (Status: ${response.statusCode})",
        );
      }
    } catch (e) {
      _showCustomSnackBar("Error: ${e.toString()}", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    subjectController.clear();
    messageController.clear();
    captchaToken.value = '';
    _validateForm();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
