import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../data/model/support_messege.dart';

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
  final storage = GetStorage();

  final String _resendApiKey = dotenv.env['RESEND_API_KEY'] ?? '';
  final String _recipientEmail = dotenv.env['ADMIN_EMAIL'] ?? '';

  @override
  void onInit() {
    super.onInit();
    loadMessages();

    [
      firstNameController,
      emailController,
      subjectController,
      messageController,
    ].forEach((element) => element.addListener(_validateForm));
  }

  void _validateForm() {
    isFormValid.value =
        firstNameController.text.isNotEmpty &&
        GetUtils.isEmail(emailController.text.trim()) &&
        subjectController.text.isNotEmpty &&
        messageController.text.isNotEmpty;
  }

  Future<void> sendMessage() async {
    if (!isFormValid.value) {
      _showSnackBar("Harap isi formulir dengan benar", isError: true);
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('https://api.resend.com/emails'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_resendApiKey",
        },
        body: jsonEncode({
          "from": "Cema Support <onboarding@resend.dev>",
          "to": [_recipientEmail],
          "subject": "Laporan Baru: ${subjectController.text}",
          "html":
              """
            <h3>Detail Laporan Baru</h3>
            <p><strong>Nama:</strong> ${firstNameController.text} ${lastNameController.text}</p>
            <p><strong>Email:</strong> ${emailController.text}</p>
            <p><strong>Telepon:</strong> ${phoneController.text}</p>
            <p><strong>Pesan:</strong> ${messageController.text}</p>
            <hr>
            <p><small>Dikirim melalui sistem Customer Support</small></p>
          """,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _saveToHistory();
        clearForm();
        _showSnackBar("Laporan Anda berhasil dikirim!");
      } else {
        throw Exception(
          "Server gagal mengirim email (Status: ${response.statusCode})",
        );
      }
    } catch (e) {
      _showSnackBar(e.toString().replaceAll("Exception:", ""), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void _saveToHistory() {
    final newMessage = SupportMessage(
      name: "${firstNameController.text} ${lastNameController.text}",
      email: emailController.text.trim(),
      subject: subjectController.text.trim(),
      message: messageController.text.trim(),
      createdAt: DateTime.now(),
    );
    messages.insert(0, newMessage);
    storage.write('supportMessages', messages.map((e) => e.toJson()).toList());
  }

  void loadMessages() {
    final savedData = storage.read<List>('supportMessages') ?? [];
    messages.assignAll(
      savedData.map(
        (e) => SupportMessage.fromJson(Map<String, dynamic>.from(e)),
      ),
    );
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(
            msg,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: isError
              ? Colors.redAccent.shade400
              : const Color(0xFF8DC63F),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    subjectController.clear();
    messageController.clear();
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
