import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TambahProyekController extends GetxController {
  // Controllers for input fields
  final namaProyek = TextEditingController();
  final deskripsiProyek = TextEditingController();

  final tanggalMulai = TextEditingController();
  final tanggalSelesai = TextEditingController();

  // Dropdown status
  final statusProyek = ''.obs;

  List<String> statusList = [
    "Belum Dimulai",
    "Sedang Berjalan",
    "Selesai"
  ];

  // Date picker function
  Future<void> pilihTanggal(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  // Submit logic
  void simpanProyek() {
    if (namaProyek.text.isEmpty) {
      Get.snackbar("Error", "Nama proyek tidak boleh kosong");
      return;
    }

    print("Nama: ${namaProyek.text}");
    print("Deskripsi: ${deskripsiProyek.text}");
    print("Tanggal Mulai: ${tanggalMulai.text}");
    print("Tanggal Selesai: ${tanggalSelesai.text}");
    print("Status: ${statusProyek.value}");

    Get.back(); // setelah berhasil simpan
  }

  @override
  void onClose() {
    namaProyek.dispose();
    deskripsiProyek.dispose();
    tanggalMulai.dispose();
    tanggalSelesai.dispose();
    super.onClose();
  }
}