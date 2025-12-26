import 'package:cema_mobile/app/data/model/policy.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import 'package:get/get.dart';

class PrivacyController extends GetxController {
  var isLoading = false.obs;

  final sections = <PolicySection>[].obs;
  final lastUpdated = '08 Desember 2025'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyData();
  }

  void fetchPrivacyData() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      sections.assignAll([
        PolicySection(
          title: 'Pendahuluan',
          body:
              'Selamat datang di aplikasi kami. Privasi dan keamanan data Anda adalah prioritas utama...',
        ),
        PolicySection(
          title: 'Data yang Dikumpulkan',
          body:
              'Kami dapat mengumpulkan beberapa jenis informasi, termasuk: \n• Data identitas \n• Data teknis \n• Data penggunaan.',
        ),
        PolicySection(
          title: 'Tujuan Penggunaan Data',
          body:
              'Data digunakan untuk menyediakan dan memperbaiki layanan serta personalisasi pengalaman pengguna.',
        ),
        PolicySection(
          title: 'Keamanan Data',
          body:
              'Kami menerapkan langkah-langkah teknis tinggi untuk melindungi data dari akses tidak sah.',
        ),
        PolicySection(
          title: 'Kontak',
          body:
              'Email: privacy@cema.id\nAlamat: Jl. Cema Design No.1, Bandung.',
        ),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> shareAsPdf() async {
    try {
      isLoading.value = true;

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  "Privacy & Policy - Cema Mobile",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Paragraph(text: "Terakhir diperbarui: ${lastUpdated.value}"),
              pw.SizedBox(height: 20),

              ...sections.map(
                (section) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      section.title,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(section.body),
                    pw.SizedBox(height: 15),
                  ],
                ),
              ),
            ];
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/Privacy_Policy_Cema.pdf");
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Halo, berikut adalah dokumen Privacy & Policy dari Cema Mobile.',
      );
    } catch (e) {
      Get.snackbar("Error", "Gagal membagikan file: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void acceptPrivacyPolicy() {
    Get.back();
    Get.snackbar(
      "Berhasil",
      "Anda telah menyetujui kebijakan privasi terbaru.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF8DC63F),
      colorText: Colors.white,
    );
  }
}
