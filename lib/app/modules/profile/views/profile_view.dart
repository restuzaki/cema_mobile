import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cema_mobile/app/modules/profile/controllers/profile_controller.dart';
import '../../../widgets/custom_circle.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomCircle(),
          Container(color: Colors.white.withOpacity(0.6)),

          Image.asset(
            'assets/images/profile_bg.png',
            fit: BoxFit.fill,
            height: 188,
            width: MediaQuery.of(context).size.width,
          ),

          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'Profil',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // Profile Header (Avatar, Name, Email)
                          Column(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage:
                                        controller.photoUrl.value.isNotEmpty
                                        ? MemoryImage(
                                            base64Decode(
                                              controller.photoUrl.value,
                                            ),
                                          )
                                        : null,
                                    child: controller.photoUrl.value.isEmpty
                                        ? Icon(
                                            Icons.person,
                                            size: 70,
                                            color: Colors.grey[400],
                                          )
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: controller.pickImage,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          size: 26,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                controller.name.value,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.email.value,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Menu Items
                          _buildMenuItem(
                            icon: Icons.person_outline,
                            title: "Perbarui Data Pribadi",
                            onTap: () => controller.toEditProfilePage(),
                          ),
                          _buildMenuItem(
                            icon: Icons.privacy_tip_outlined,
                            title: "Privasi & Kebijakan",
                            onTap: () => Get.toNamed('/privacy-and-policy'),
                          ),
                          _buildMenuItem(
                            icon: Icons.support_agent_outlined,
                            title: "Customer Support",
                            onTap: () => Get.toNamed('/cs-support'),
                          ),

                          const SizedBox(height: 16),

                          // Logout Button
                          InkWell(
                            onTap: controller.logout,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(
                                  0.1,
                                ), // Opacity lebih rendah agar teks terbaca
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.logout, color: Colors.red),
                                  const SizedBox(width: 16),
                                  const Text(
                                    "Logout",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
