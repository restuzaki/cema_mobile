import 'package:cema_mobile/app/modules/tambah_proyek/controllers/tambah_proyek_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahProyekPage extends GetView<TambahProyekController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Tambah Proyek",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            const Text(
              "Detail Proyek",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),

            // INPUT NAMA PROYEK
            TextField(
              controller: controller.namaProyek,
              decoration: InputDecoration(
                labelText: "Nama Proyek",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // DESKRIPSI PROYEK
            TextField(
              controller: controller.deskripsiProyek,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Deskripsi Proyek",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // TANGGAL MULAI
            TextField(
              controller: controller.tanggalMulai,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Tanggal Mulai Proyek",
                border: OutlineInputBorder(),
              ),
              onTap: () => controller.pilihTanggal(controller.tanggalMulai),
            ),
            const SizedBox(height: 20),

            // TANGGAL SELESAI
            TextField(
              controller: controller.tanggalSelesai,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Tanggal Selesai Proyek",
                border: OutlineInputBorder(),
              ),
              onTap: () =>
                  controller.pilihTanggal(controller.tanggalSelesai),
            ),
            const SizedBox(height: 20),

            // STATUS PROYEK
            Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.statusProyek.value.isEmpty
                    ? null
                    : controller.statusProyek.value,
                items: controller.statusList
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.statusProyek.value = value;
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Status Proyek",
                  border: OutlineInputBorder(),
                ),
              );
            }),

            const SizedBox(height: 30),

            // BUTTON SIMPAN
            ElevatedButton.icon(
              onPressed: controller.simpanProyek,
              icon: const Icon(Icons.edit, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8BC34A),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              label: Text(
                "Tambah Task",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}