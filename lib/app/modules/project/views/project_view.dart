import 'package:cema_mobile/app/widgets/cema_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/tokens/typography.dart';
import '../controllers/project_controller.dart';
import '../widgets/widget_icon_button.dart';
import '../widgets/widget_project_card.dart';
import '../widgets/widget_stat_card.dart';

class ProjectView extends GetView<ProjectController> {
  const ProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildStatsRow(),
            const SizedBox(height: 24),
            _buildProjectListSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, Nicholas!', // Dynamic user name ideally
                style: AppTypography.headingLG,
              ),
              const SizedBox(height: 4),
              Text(
                'Selamat Pagi',
                style: AppTypography.bodyMD.copyWith(
                  color: AppColors.neutral700,
                ),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.neutral300,
            // backgroundImage: NetworkImage('...'),
            child: Icon(Icons.person, color: AppColors.neutral700),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Statistik', style: AppTypography.headingMD),
              WidgetIconButton(
                icon: Icons.picture_as_pdf, // Using generic icon for PDF
                onTap: () {},
                backgroundColor: AppColors.neutral100,
                iconColor: AppColors.neutral700,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => Row(
              children: [
                WidgetStatCard(
                  label: 'Total',
                  value: controller.totalProjects.toString(),
                  trend: '+2 New',
                  isTrendPositive: true,
                ),
                const SizedBox(width: 12),
                WidgetStatCard(
                  label: 'Active',
                  value: controller.activeProjects.toString(),
                  trend: 'On Track',
                ),
                const SizedBox(width: 12),
                WidgetStatCard(
                  label: 'Done',
                  value: controller.completedProjects.toString(),
                  trend: 'Last 30d',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectListSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: AppColors.neutral000,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          // boxShadow: [AppShadows.cardShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildTabFilters(),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.filteredProjects.isEmpty) {
                  return Center(
                    child: Text(
                      'No projects found',
                      style: AppTypography.bodyMD,
                    ),
                  );
                }

                // Note: Actual filtering logic for tabs would go here.
                // For now showing all projects as per current requirement simplified.
                return ListView.builder(
                  itemCount: controller.filteredProjects.length,
                  itemBuilder: (context, index) {
                    final project = controller.filteredProjects[index];
                    return WidgetProjectCard(project: project);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabFilters() {
    return Obx(
      () => Row(
        children: [
          _buildTabItem(
            'All',
            index: 0,
            isSelected: controller.currentTab.value == 0,
          ),
          const SizedBox(width: 24),
          _buildTabItem(
            'Berlangsung',
            index: 1,
            isSelected: controller.currentTab.value == 1,
          ),
          const SizedBox(width: 24),
          _buildTabItem(
            'Selesai',
            index: 2,
            isSelected: controller.currentTab.value == 2,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    String label, {
    required int index,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Column(
        children: [
          Text(
            label,
            style: isSelected
                ? AppTypography.labelSmall.copyWith(color: AppColors.primary500)
                : AppTypography.bodySM.copyWith(color: AppColors.neutral500),
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.primary500,
                shape: BoxShape.circle,
              ),
            )
          else
            // Placeholder to keep height consistent prevent jumping
            const SizedBox(height: 4),
        ],
      ),
    );
  }
}
