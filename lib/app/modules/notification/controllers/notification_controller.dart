import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // 🔔 TAMBAHAN

import '../notification_model.dart';
import 'package:cema_mobile/app/service/local_notification_service.dart'; // 🔔 TAMBAHAN

class NotificationController extends GetxController {
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();

    loadNotifications(); // data dummy (tidak diubah)
    _initFCMListener();  // 🔔 TAMBAHAN
  }

  void loadNotifications() {
    notifications.value = [
      NotificationItem(
        title: "Task Name",
        subtitle: "Project Name",
        hasAction: true,
        timestamp: "Yesterday",
        avatars: ['A', 'B', 'C'],
      ),
      NotificationItem(
        title: "Project Name",
        subtitle: "Desc",
        amount: "Rp 90.000.000",
        hasAction: true,
        timestamp: "Today",
        avatars: ['D'],
      ),
      NotificationItem(
        title: "Project Name",
        subtitle: "Notification Details",
        hasAction: false,
        timestamp: "Last week",
      ),
    ];
  }

  /// 🔔 TAMBAHAN
  /// Listener FCM (saat app foreground)
  void _initFCMListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? 'Notifikasi';
      final body = message.notification?.body ?? '';

      // 1️⃣ Tampilkan push notification
      LocalNotificationService.show(
        title: title,
        body: body,
      );

      // 2️⃣ Masukkan ke list notifikasi (UI)
      notifications.insert(
        0,
        NotificationItem(
          title: title,
          subtitle: body,
          hasAction: false,
          timestamp: 'Just now',
        ),
      );
    });
  }

  /// 🔔 TAMBAHAN (opsional tapi disarankan)
  /// Ambil FCM token (bisa dipanggil dari page / init)
  Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }
}
