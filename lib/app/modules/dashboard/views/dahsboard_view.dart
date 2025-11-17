import 'package:cema_mobile/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:cema_mobile/app/modules/project_detail/view/project_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/risk.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color greenColor = Color(0xFF8DC63F);
    const Color redColor = Color(0xFFC94040);
    const Color lightGreenColor = Color(0xFFEAF5DC);
    const Color lightGreyColor = Color(0xFFF5F5F5);

    return Stack(
      children: [
        Scaffold(
          appBar: _buildAppBar(),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("Pesan Saya"),
                const SizedBox(height: 16),
                _buildTaskCard(greenColor, redColor, lightGreenColor),
                const SizedBox(height: 16),
                _buildProjectCard(greenColor, redColor, lightGreyColor),
                const SizedBox(height: 24),
                _buildSectionHeader("Proyek Berisiko"),
                const SizedBox(height: 16),
                _buildRiskyProjectHeader(Colors.black),
                const SizedBox(height: 20),
                _buildRiskyProjectList(),
              ],
            ),
          ),
        ),
        _buildFabMenu(greenColor),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      title: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Asep Toktok",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                "Project Manager",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF7AC943), width: 2),
          ),
          child: const Icon(
            Icons.notifications_none,
            size: 22,
            color: Color(0xFF7AC943),
          ),
        ),
        const SizedBox(width: 16),
        const CircleAvatar(
          radius: 34,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=56'),
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Lihat Semua",
            style: TextStyle(
              color: Color(0xFF8DC63F),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard(
    Color greenColor,
    Color redColor,
    Color lightGreenColor,
  ) {
    return Card(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Task Name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Project Name",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.person_outline, color: Colors.green),
                    const SizedBox(width: 6),
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=1',
                      ),
                    ),
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=2',
                      ),
                    ),
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=3',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 55,
                      width: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: lightGreenColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: Colors.yellowAccent.shade700,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      height: 55,
                      width: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: lightGreenColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.attach_file,
                        color: greenColor,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => controller.acceptTask("TASK123"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text("Accept"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => controller.rejectTask("TASK123"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: redColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text("Reject"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(
    Color greenColor,
    Color redColor,
    Color lightGreyColor,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Project Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text("Desc", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: lightGreyColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Text("Phase", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: lightGreyColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.monetization_on_rounded,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Rp 90.000.000",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => controller.acceptTask("TASK123"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text("Accept"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => controller.rejectTask("TASK123"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: redColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text("Reject"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskyProjectList() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.filteredProjects.length,
        itemBuilder: (context, index) {
          final project = controller.filteredProjects[index];
          return _buildRiskyProjectCard(project);
        },
      ),
    );
  }

  Widget _buildRiskyProjectHeader(Color blackColor) {
    final List<String> tabs = ["All", "Darurat", "Berisiko"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Obx(
                () => Row(
                  children: List.generate(tabs.length, (index) {
                    bool isSelected =
                        controller.selectedRiskTabIndex.value == index;
                    return GestureDetector(
                      onTap: () => controller.changeRiskTab(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        margin: const EdgeInsets.only(right: 12),
                        decoration: isSelected
                            ? BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: blackColor,
                                    width: 3,
                                  ),
                                ),
                              )
                            : null,
                        child: Text(
                          tabs[index],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.black
                                : Colors.grey.shade600,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRiskyProjectCard(Project project) {
    Color riskTagColor;
    Color riskBgColor;
    String riskText;

    switch (project.riskType) {
      case RiskType.berisiko:
        riskTagColor = const Color(0xFFC59400);
        riskBgColor = const Color(0xFFFFF7E6);
        riskText = "Berisiko";
        break;
      case RiskType.darurat:
        riskTagColor = const Color(0xFFC94040);
        riskBgColor = const Color(0xFFFEE6E6);
        riskText = "Darurat";
        break;
      case RiskType.normal:
      default:
        riskTagColor = Colors.grey.shade600;
        riskBgColor = Colors.grey.shade200;
        riskText = "Normal";
        break;
    }

    Color cpiColor = project.cpi < 0.9
        ? const Color(0xFFC94040)
        : const Color(0xFF8DC63F);
    Color spiColor = project.spi < 0.9
        ? const Color(0xFFC94040)
        : const Color(0xFF8DC63F);
    Color cpiBgColor = project.cpi < 0.9
        ? const Color(0xFFFEE6E6)
        : const Color(0xFFEAF5DC);
    Color spiBgColor = project.spi < 0.9
        ? const Color(0xFFFEE6E6)
        : const Color(0xFFEAF5DC);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.grey.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          project.phase,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: riskBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: riskTagColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        riskText,
                        style: TextStyle(
                          color: riskTagColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildMetricChip("CPI", project.cpi, cpiColor, cpiBgColor),
                const SizedBox(width: 12),
                _buildMetricChip("SPI", project.spi, spiColor, spiBgColor),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Get.snackbar("Detail", "Melihat detail ${project.name}");
                  
                  },
                  child: Row(
                    children: [
                      Text(
                        "Lihat Detail",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip(
    String label,
    double value,
    Color textColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniFab({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: color, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }

  Widget _buildFabMenu(Color greenColor) {
    return Positioned(
      bottom: 20.0,
      right: 20.0,
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AnimatedSlide(
              offset: controller.isFabMenuOpen.value
                  ? Offset.zero
                  : const Offset(0, 0.5),
              duration: const Duration(milliseconds: 200),
              child: AnimatedOpacity(
                opacity: controller.isFabMenuOpen.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: !controller.isFabMenuOpen.value,
                  child: Column(
                    children: [
                      _buildMiniFab(
                        icon: Icons.monetization_on_outlined,
                        color: greenColor,
                        onPressed: () {
                          controller.toggleFabMenu();
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildMiniFab(
                        icon: Icons.library_books,
                        color: greenColor,
                        onPressed: () {
                          controller.toggleFabMenu();
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: controller.toggleFabMenu,
              backgroundColor: greenColor,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: const CircleBorder(),
              child: AnimatedRotation(
                turns: controller.isFabMenuOpen.value ? 0 : 500,
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  controller.isFabMenuOpen.value ? Icons.close : Icons.add,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
