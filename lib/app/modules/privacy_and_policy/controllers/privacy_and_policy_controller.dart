import 'package:cema_mobile/app/data/model/policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
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
          title: '1. Pendahuluan',
          body:
              'Selamat datang di Cema Mobile. Kami berkomitmen untuk melindungi privasi Anda. Kebijakan ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan menjaga informasi pribadi Anda saat menggunakan aplikasi kami. Dengan menggunakan layanan kami, Anda menyetujui praktik yang dijelaskan dalam dokumen ini.',
        ),
        PolicySection(
          title: '2. Data yang Kami Kumpulkan',
          body:
              'Kami mengumpulkan informasi untuk memberikan layanan yang lebih baik kepada semua pengguna kami, antara lain:\n'
              '• Informasi Identitas: Nama, alamat email, dan nomor telepon yang Anda berikan saat registrasi.\n'
              '• Data Teknis: Alamat protokol internet (IP), jenis perangkat, dan versi sistem operasi.\n'
              '• Log Penggunaan: Riwayat interaksi Anda di dalam aplikasi untuk keperluan analisis performa.',
        ),
        PolicySection(
          title: '3. Tujuan Penggunaan Data',
          body:
              'Informasi yang kami kumpulkan digunakan untuk:\n'
              '• Memelihara dan meningkatkan kualitas layanan Cema Mobile.\n'
              '• Mengembangkan fitur-fitur baru berdasarkan kebutuhan pengguna.\n'
              '• Melindungi keamanan sistem kami dan mencegah aktivitas penipuan.\n'
              '• Mengirimkan pemberitahuan penting terkait perubahan kebijakan atau pembaruan aplikasi.',
        ),
        PolicySection(
          title: '4. Keamanan dan Perlindungan Data',
          body:
              'Keamanan data Anda adalah prioritas kami. Kami menerapkan enkripsi SSL/TLS untuk transmisi data dan menggunakan firewall tingkat tinggi untuk melindungi server kami dari akses yang tidak sah. Kami secara rutin meninjau praktik pengumpulan dan penyimpanan data kami.',
        ),
        PolicySection(
          title: '5. Hak Pengguna',
          body:
              'Anda berhak untuk mengakses, memperbarui, atau menghapus informasi pribadi Anda kapan saja melalui pengaturan akun. Jika Anda ingin menarik persetujuan Anda atas penggunaan data, silakan hubungi tim dukungan kami.',
        ),
        PolicySection(
          title: '6. Kontak Kami',
          body:
              'Jika Anda memiliki pertanyaan tentang Kebijakan Privasi ini, silakan hubungi kami di:\n'
              'Email: privacy@cema.id\n'
              'Alamat: Jl. Cema Design No.1, Bandung, Jawa Barat.',
        ),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> shareAsPdf(BuildContext context) async {
    try {
      isLoading.value = true;

      final ByteData bytes = await rootBundle.load(
        'assets/images/logo_cema.png',
      );
      final Uint8List byteList = bytes.buffer.asUint8List();
      final logoImage = pw.MemoryImage(byteList);

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context pdfContext) {
            return [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "PRIVACY & POLICY",
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green800,
                        ),
                      ),
                      pw.Text(
                        "Cema Mobile - Official Document",
                        style: const pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    height: 50,
                    width: 50,
                    child: pw.Image(logoImage),
                  ),
                ],
              ),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 10),
              pw.Paragraph(
                text: "Terakhir diperbarui: ${lastUpdated.value}",
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
              pw.SizedBox(height: 20),

              // Isi Kebijakan
              ...sections.map(
                (section) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      section.title,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      section.body,
                      style: const pw.TextStyle(fontSize: 11),
                      textAlign: pw.TextAlign.justify,
                    ),
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal membagikan file: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void acceptPrivacyPolicy(BuildContext context) {
    Get.back();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Anda telah menyetujui kebijakan privasi terbaru."),
        backgroundColor: Color(0xFF8DC63F),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
