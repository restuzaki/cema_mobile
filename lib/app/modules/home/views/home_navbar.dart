import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cema_mobile/app/modules/dashboard/views/dahsboard_view.dart';
import 'package:cema_mobile/app/modules/profile/views/profile_view.dart';
import '../../../widgets/custom_navbar.dart';
import '../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController controller = Get.put(HomeController());

  final List<Widget> _pages = [
    DashboardView(),
    // 2
    ProfilePage(),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 41, 37, 37),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomNavButton(
                icon: Icons.home,
                label: "Dashboard",
                isSelected: controller.selectedIndex.value == 0,
                onTap: () => controller.changeTabIndex(0),
              ),
              CustomNavButton(
                icon: Icons.stacked_bar_chart,
                label: "Project",
                isSelected: controller.selectedIndex.value == 1,
                onTap: () => controller.changeTabIndex(1),
              ),
              CustomNavButton(
                icon: Icons.person,
                label: "Profile",
                isSelected: controller.selectedIndex.value == 2,
                onTap: () => controller.changeTabIndex(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
