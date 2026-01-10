// lib/app/modules/notification/views/notification_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cema_mobile/app/modules/notification/controllers/notification_controller.dart';
import '../widgets/notification_card_pm.dart';
import '../widgets/notification_card_staff.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Tidak ada notifikasi',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadNotifications,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tab "Semua" & "Belum Dibaca"
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                        ),
                        child: Text(
                          "Semua",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text(
                        "Belum Dibaca",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Section "Hari ini" - Items that need action
                Text(
                  "Hari ini",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                ...controller.notifications.where((item) => item.hasAction).map(
                  (item) {
                    return NotificationCardPM(item: item);
                  },
                ).toList(),

                const SizedBox(height: 32),

                // Section "Pesan Lainnya" - Approved/Rejected items
                if (controller.notifications.any(
                  (item) => !item.hasAction,
                )) ...[
                  Text(
                    "Pesan Lainnya",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ...controller.notifications
                      .where((item) => !item.hasAction)
                      .map((item) {
                        return NotificationCardStaff(item: item);
                      })
                      .toList(),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
