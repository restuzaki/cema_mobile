import 'package:cema_mobile/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/project_detail_controller.dart';
import '../tabs/task_tab_content.dart';
import '../tabs/finance_tab_content.dart';

class ProjectDetailView extends StatelessWidget {
  const ProjectDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectDetailController());

    return Scaffold(
      backgroundColor: AppColors.neutral000,
      appBar: CustomHeader(
        title: 'Project Name',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => CustomFilter(
                label: 'Tugas',
                isActive: controller.mainTabIndex.value == 0,
                onTap: () => controller.changeMainTab(0),
              ),
            ),
            SizedBox(width: AppSpacing.xl),
            Obx(
              () => CustomFilter(
                label: 'Keuangan',
                isActive: controller.mainTabIndex.value == 1,
                onTap: () => controller.changeMainTab(1),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomButton(
        text: controller.mainTabIndex.value == 0
            ? 'Tambah Tugas'
            : 'Tambah Transaksi',
        size: ButtonSize.large,
        variant: ButtonVariant.primary,
        icon: Icons.add,
        onPressed: () {
          Get.toNamed(controller.mainTabIndex.value == 0 ? '' : '');
        },
      ),
      bottomNavigationBar: CustomNavbar(
        currentIndex: 1,
        onTap: (RxInt) {},
        items: const [
          CustomNavbarItem(label: 'Beranda', icon: Icons.home),
          CustomNavbarItem(label: 'Projek', icon: Icons.view_agenda_outlined),
          CustomNavbarItem(label: 'Profil', icon: Icons.person),
        ],
      ),
      body: SafeArea(
        minimum: AppSpacing.only(bottom: AppSpacing.lg),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => SingleChildScrollView(
                  padding: AppSpacing.paddingMd,
                  child: controller.mainTabIndex.value == 0
                      ? TaskTabContent(controller: controller)
                      : FinanceTabContent(controller: controller),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
