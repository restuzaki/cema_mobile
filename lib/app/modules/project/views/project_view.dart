import 'package:cema_mobile/app/design_system/tokens/dimensions.dart';
import 'package:cema_mobile/app/design_system/tokens/shadows.dart';
import 'package:cema_mobile/app/widgets/cema_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../design_system/tokens/colors.dart';
import '../../../design_system/tokens/typography.dart';
import '../controllers/project_controller.dart';
import '../widgets/widget_project_card.dart';
import '../widgets/widget_stat_card.dart';

class ProjectView extends GetView<ProjectController> {
  final VoidCallback? onAvatarClicked;
  const ProjectView({super.key, this.onAvatarClicked});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                expandedHeight: _getAppBarHeight(),
                backgroundColor: AppColors.neutral000,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: AppSpacing.only(bottom: AppSpacing.xxs),
                    child: Obx(
                      () => CemaHomeAppBar(
                        title: controller.userName.value,
                        subtitle: controller.userRole.value,
                        imageUrl: controller.profilePic.value,
                        onAvatarClicked: onAvatarClicked,
                      ),
                    ),
                  ),
                ),
              ),

              SliverAppBar(
                expandedHeight: _getStatsRowHeight(),
                backgroundColor: AppColors.neutral000,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: AppSpacing.only(
                      top: AppSpacing.md,
                      bottom: AppSpacing.xxs,
                    ),
                    child: Padding(
                      padding: AppSpacing.symmetric(horizontal: AppSpacing.md),
                      child: _buildStatsRow(),
                    ),
                  ),
                ),
              ),

              SliverAppBar(
                pinned: true,
                toolbarHeight: _getTabFiltersHeight(),
                expandedHeight: _getTabFiltersHeight(),
                backgroundColor: AppColors.neutral000,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: AppSpacing.paddingMd,
                    child: _buildTabFilters(),
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: controller.filteredProjects.length,
                  (context, index) {
                    return WidgetProjectCard(
                      project: controller.filteredProjects[index],
                      onTap: () => controller.navigateToDetail(
                        controller.filteredProjects[index],
                      ),
                    );
                  },
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 96)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutral000,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.shadowMd,
      ),
      padding: AppSpacing.all(AppSpacing.md),
      child: Column(
        spacing: AppSpacing.sm,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Statistik', style: AppTypography.headingMD),
              // WidgetIconButton(
              //   icon: Icons.picture_as_pdf,
              //   onTap: () {},
              //   backgroundColor: AppColors.neutral100,
              //   iconColor: AppColors.neutral700,
              // ),
            ],
          ),
          Obx(
            () => Row(
              spacing: AppSpacing.sm,
              children: [
                Expanded(
                  child: WidgetStatCard(
                    label: 'Total',
                    value: controller.totalProjects.toString(),
                    trend: '+2 New',
                    isTrendPositive: true,
                  ),
                ),
                Expanded(
                  child: WidgetStatCard(
                    label: 'Active',
                    value: controller.activeProjects.toString(),
                    trend: 'On Track',
                  ),
                ),
                Expanded(
                  child: WidgetStatCard(
                    label: 'Done',
                    value: controller.completedProjects.toString(),
                    trend: 'Last 30d',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabFilters() {
    return Obx(
      () => Padding(
        padding: AppSpacing.symmetric(horizontal: AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.md,
          children: [
            Text("Daftar Proyek", style: AppTypography.headingMD),
            Row(
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
          ],
        ),
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

  double _getAppBarHeight() {
    return CemaHomeAppBar(
          title: controller.userName.value,
          subtitle: controller.userRole.value,
          imageUrl: controller.profilePic.value,
          onAvatarClicked: onAvatarClicked,
        ).preferredSize.height +
        AppSpacing.xxs;
  }

  double _getStatsRowHeight() {
    return AppTypography.headingMD.fontSize! * AppTypography.headingMD.height! +
        2 * AppSpacing.md +
        AppSpacing.xl +
        WidgetStatCard.height;
  }

  double _getTabFiltersHeight() {
    return AppTypography.headingMD.fontSize! * AppTypography.headingMD.height! +
        3 * AppSpacing.md +
        8 +
        AppSpacing.lg;
  }
}
