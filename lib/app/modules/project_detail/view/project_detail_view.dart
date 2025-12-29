import 'package:cema_mobile/app/design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cema_mobile/app/routes/app_pages.dart';
import '../controller/project_detail_controller.dart';
import '../tabs/task_tab_content.dart';
import '../tabs/finance_tab_content.dart';
import '../tabs/settings_tab_content.dart';

class ProjectDetailView extends StatelessWidget {
  const ProjectDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectDetailController());

    return Scaffold(
      backgroundColor: AppColors.neutral000,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: Obx(
          () => CustomHeader(
            title: controller.currentProject?.name ?? 'Project Name',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomFilter(
                  label: 'Tugas',
                  isActive: controller.mainTabIndex.value == 0,
                  onTap: () => controller.changeMainTab(0),
                ),
                SizedBox(width: AppSpacing.xl),
                CustomFilter(
                  label: 'Keuangan',
                  isActive: controller.mainTabIndex.value == 1,
                  onTap: () => controller.changeMainTab(1),
                ),
                SizedBox(width: AppSpacing.xl),
                CustomFilter(
                  label: 'Pengaturan',
                  isActive: controller.mainTabIndex.value == 2,
                  onTap: () => controller.changeMainTab(2),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => controller.mainTabIndex.value == 2
            ? SizedBox.shrink()
            : CustomButton(
                text: controller.mainTabIndex.value == 0
                    ? 'Tambah Tugas'
                    : 'Tambah Transaksi',
                size: ButtonSize.large,
                variant: ButtonVariant.primary,
                icon: Icons.add,
                onPressed: () {
                  if (controller.mainTabIndex.value == 0) {
                    Get.toNamed(Routes.TAMBAH_TASK);
                  } else {
                    Get.snackbar(
                      'Info',
                      'Tambah Transaksi akan segera hadir',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  }
                },
              ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SafeArea(
          minimum: AppSpacing.only(bottom: AppSpacing.lg),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.paddingMd,
                  child: controller.mainTabIndex.value == 0
                      ? TaskTabContent(controller: controller)
                      : controller.mainTabIndex.value == 1
                      ? FinanceTabContent(controller: controller)
                      : SettingsTabContent(controller: controller),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
