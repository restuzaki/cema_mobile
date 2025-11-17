// lib/app/routes/main_navigation.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cema_mobile/app/design_system/design_system.dart';

/// Main navigation controller for bottom navbar
class MainNavigationController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  // Define your navigation items
  static const List<CustomNavbarItem> navItems = [
    CustomNavbarItem(label: 'Beranda', icon: Icons.home),
    CustomNavbarItem(label: 'Projek', icon: Icons.view_agenda_outlined),
    CustomNavbarItem(label: 'Profil', icon: Icons.person),
  ];
}

/// Main navigation view with bottom navbar
class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainNavigationController());

    return Scaffold(
      body: Obx(() => _getPage(controller.currentIndex.value)),
      bottomNavigationBar: Obx(
        () => CustomNavbar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          items: MainNavigationController.navItems,
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _BerandaPage();
      case 1:
        return _ProjekPage();
      case 2:
        return _ProfilPage();
      default:
        return _BerandaPage();
    }
  }
}

// Placeholder pages - replace with your actual pages
class _BerandaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: AppColors.primary500,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 64, color: AppColors.primary500),
            SizedBox(height: AppSpacing.md),
            Text('Beranda Page', style: AppTypography.headingLG),
          ],
        ),
      ),
    );
  }
}

class _ProjekPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projek'),
        backgroundColor: AppColors.primary500,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.view_agenda_outlined,
              size: 64,
              color: AppColors.primary500,
            ),
            SizedBox(height: AppSpacing.md),
            Text('Projek Page', style: AppTypography.headingLG),
          ],
        ),
      ),
    );
  }
}

class _ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: AppColors.primary500,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 64, color: AppColors.primary500),
            SizedBox(height: AppSpacing.md),
            Text('Profil Page', style: AppTypography.headingLG),
          ],
        ),
      ),
    );
  }
}
