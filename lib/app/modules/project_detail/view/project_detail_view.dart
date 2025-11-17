import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/project_detail_controller.dart';

class ProjectDetailView extends StatelessWidget {
  const ProjectDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectDetailController());
    final green = const Color(0xFF7CC244);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // back circle
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: green, width: 2),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.arrow_back, color: green),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Project Name',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // main tabs (centered and larger)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Obx(() => GestureDetector(
                        onTap: () => controller.changeMainTab(0),
                        child: Text(
                          'Tugas',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: controller.mainTabIndex.value == 0
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: controller.mainTabIndex.value == 0
                                ? Colors.black
                                : Colors.grey[400],
                          ),
                        ),
                      )),
                  const SizedBox(width: 36),
                  Obx(() => GestureDetector(
                        onTap: () => controller.changeMainTab(1),
                        child: Text(
                          'Keuangan',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: controller.mainTabIndex.value == 1
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: controller.mainTabIndex.value == 1
                                ? Colors.black
                                : Colors.grey[350],
                          ),
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // content card
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Daftar Tugas',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // small filters
                          Obx(() => Row(
                                children: List.generate(4, (i) {
                                  final labels = ['Semua', 'Berlangsung', 'Terlambat', 'Selesai'];
                                  final active = controller.taskFilterIndex.value == i;
                                  return GestureDetector(
                                    onTap: () => controller.changeTaskFilter(i),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 18),
                                      child: Column(
                                        children: [
                                          Text(
                                            labels[i],
                                            style: TextStyle(
                                              color: active ? Colors.black : Colors.grey[400],
                                              fontWeight: active ? FontWeight.bold : FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          if (active)
                                            Container(
                                              width: 18,
                                              height: 3,
                                              color: Colors.black,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              )),

                          const SizedBox(height: 12),

                          // task list
                          Obx(() {
                            final list = controller.filteredTasks;
                            return Column(
                              children: List.generate(list.length, (i) {
                                final t = list[i];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // left info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                t['title'] ?? '',
                                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                t['project'] ?? '',
                                                style: TextStyle(color: Colors.grey[600]),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Due Date',
                                                style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // right column: phase and button
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                                                const SizedBox(width: 6),
                                                Text(
                                                  t['phase'] ?? '',
                                                  style: TextStyle(color: Colors.grey[600]),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 18),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: green,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                                elevation: 4,
                                              ),
                                              onPressed: () {},
                                              child: const Text('Lihat Detail', style: TextStyle(color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            );
                          }),

                          const SizedBox(height: 28),

                          // spacer for floating button overlap
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // floating-like add button aligned to bottom-right (upsized)
            Padding(
              padding: const EdgeInsets.only(right: 22, bottom: 16),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // example add task
                    controller.addTask({
                      'title': 'Task',
                      'project': 'Project',
                      'dueDate': '25 Des',
                      'phase': 'Phase',
                      'status': 'ongoing',
                    });
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  label: const Text('Tambah Tugas', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    minimumSize: const Size(200, 60),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    elevation: 6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
