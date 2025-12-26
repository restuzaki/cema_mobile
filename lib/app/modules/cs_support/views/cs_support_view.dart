import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../data/model/support_messege.dart';
import '../controllers/cs_support_controller.dart';

class CustomerSupportPage extends GetView<CustomerSupportController> {
  const CustomerSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color greenColor = Color(0xFF8DC63F);
    const Color lightGreyColor = Color(0xFFF5F5F5);

    // Inisialisasi controller untuk widget Captcha
    final RecaptchaV2Controller recaptchaController = RecaptchaV2Controller();
    final String siteKeyV2 = dotenv.env['RECAPTCHA_SITE_KEY'] ?? '';
    final String _baseUrl = dotenv.env['API_KEY'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Kirim Laporan Baru"),
            const SizedBox(height: 16),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller.firstNameController,
                            "First Name",
                            Icons.person_outline,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller.lastNameController,
                            "Last Name",
                            Icons.person_outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller.emailController,
                      "Email Address",
                      Icons.email_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller.phoneController,
                      "Phone Number",
                      Icons.phone_android_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller.subjectController,
                      "Judul / Subjek",
                      Icons.title_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller.messageController,
                      "Detail Masalah",
                      Icons.description_outlined,
                      maxLines: 4,
                    ),

                    const SizedBox(height: 20),

                    RecaptchaV2(
                      apiKey: siteKeyV2,
                      apiSecret: dotenv.env['RECAPTCHA_SECRET_KEY'] ?? '',
                      pluginURL: "https://www.google.com/recaptcha/api2/demo",
                      controller: recaptchaController,

                      onVerifiedSuccessfully: (bool isVerified) {
                        if (isVerified) {
                        } else {
                          controller.captchaToken.value = '';
                        }
                      },
                      onVerifiedError: (String error) {
                        print("Captcha Error: $error");
                      },
                    ),

                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.sendMessage(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade300,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Kirim Laporan",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionHeader("Riwayat Laporan"),
            const SizedBox(height: 16),

            Obx(() {
              if (controller.messages.isEmpty) return _buildEmptyState();
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return _buildHistoryCard(msg, lightGreyColor);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  // --- Widget Helper (Sama seperti sebelumnya) ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Customer Support",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Text(
            "Hubungi kami untuk bantuan",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) => Text(
    title,
    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );

  Widget _buildTextField(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey, size: 20),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        contentPadding: const EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF8DC63F)),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(SupportMessage msg, Color lightGreyColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  msg.subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: lightGreyColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Terkirim",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              msg.message,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            const Divider(height: 24),
            Text(
              "${msg.createdAt.day}/${msg.createdAt.month} - ${msg.createdAt.hour}:${msg.createdAt.minute}",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() => Center(
    child: Text(
      "Belum ada riwayat laporan",
      style: TextStyle(color: Colors.grey.shade500),
    ),
  );
}
