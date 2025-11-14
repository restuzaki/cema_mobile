import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_manager_controller.dart';

class TaskManagerPage extends GetView<TaskManagerController> {
  const TaskManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Warna background dasar
      appBar: AppBar(
        title: const Text(
          "Project Overview",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20),
        ),
        backgroundColor: Colors.transparent, // Agar menyatu dengan background
        elevation: 0,
        centerTitle: false, // Judul rata kiri sesuai desain
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Container hijau muda yang melengkung
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4F4), // Warna hijau tosca muda mirip desain
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  // Header "Project" dan titik tiga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Project",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Icon(Icons.more_vert, color: Colors.grey),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  // List Project
                  Expanded(
                    child: Obx(() => ListView.separated(
                      itemCount: controller.progress.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final project = controller.progress[index];
                        return _buildProjectCard(project);
                      },
                    )),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16), // Spasi bawah sebelum navbar (jika ada)
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    // Konversi progress dari skala 100 ke skala 0.0 - 1.0 untuk LinearProgressIndicator
    double progressPercent = ((project['progress'] ?? 0) as num).toDouble();
    double progressValue = progressPercent / 100.0;

    return InkWell(
      onTap: () => controller.goToDetail(project),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6), // Putih agak transparan
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kolom Teks Kiri
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project['owner'], // Mengakses Map dengan key 'owner'
                      style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project['title'], // Mengakses Map dengan key 'title'
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF2D3E40)),
                    ),
                  ],
                ),
                // Teks Persentase Kanan
                Text(
                  "${progressPercent.toInt()} %",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progressValue, // Nilai harus antara 0.0 - 1.0
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)), // Warna biru
              ),
            ),
          ],
        ),
      ),
    );
  }
}