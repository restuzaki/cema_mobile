import 'package:cema_mobile/app/modules/task_manager/views/task_manager_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cema_mobile/app/modules/dashboard/views/dahsboard_view.dart';
import 'package:cema_mobile/app/modules/profile/views/profile_view.dart';
import 'package:cema_mobile/app/design_system/design_system.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  static final List<Widget> _pages = [
    DashboardView(),
    TaskManagerPage(),
    ProfilePage(),
  ];

  static const List<CustomNavbarItem> _navItems = [
    CustomNavbarItem(label: 'Dashboard', icon: Icons.home),
    CustomNavbarItem(label: 'Project', icon: Icons.view_agenda_outlined),
    CustomNavbarItem(label: 'Profile', icon: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: _pages,
        ),
      ),
      floatingActionButton: _buildFabMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Obx(
        () => CustomNavbar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTabIndex,
          items: _navItems,
        ),
      ),
    );
  }

  Widget _buildFabMenu() {
    return Obx(() {
      final isExpanded = controller.isFabExpanded.value;

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isExpanded) ...[
            _buildFabOption(
              icon: Icons.attach_money,
              onTap: () {
                controller.toggleFab();
                Get.toNamed('/tambah-proyek');
              },
            ),
            SizedBox(height: AppSpacing.sm),
            _buildFabOption(
              icon: Icons.assignment_outlined,
              onTap: () {
                controller.toggleFab();
                // Navigate to add task page
                Get.toNamed('/tambah-task');
              },
            ),
            SizedBox(height: AppSpacing.md),
          ],
          CustomFab(
            icon: isExpanded ? Icons.close : Icons.add,
            onPressed: controller.toggleFab,
            variant: FabVariant.primary,
            size: FabSize.large,
          ),
        ],
      );
    });
  }

  Widget _buildFabOption({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return CustomFab(
      icon: icon,
      onPressed: onTap,
      variant: FabVariant.secondary,
      size: FabSize.large,
    );
  }
}
