import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init({
    Function(Map<String, dynamic>)? onNotificationTap,
  }) async {
    print('🔔 LocalNotificationService: Initializing...');

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: null,
    );

    // Handle notification tap
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('🔔 Notification tapped: ${response.payload}');
        if (response.payload != null && onNotificationTap != null) {
          try {
            // Parse JSON payload to Map
            final Map<String, dynamic> data = Map<String, dynamic>.from(
              response.payload as Map? ?? {},
            );
            onNotificationTap(data);
          } catch (e) {
            print('❌ Error parsing notification payload: $e');
          }
        }
      },
    );

    // 🔔 CRITICAL: Create Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel', // id
      'Default Notifications', // name
      description:
          'This channel is used for important notifications from Firebase',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    print(
      '🔔 LocalNotificationService: Initialization complete with notification channel',
    );
  }

  static Future<void> show({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    print(
      '🔔 LocalNotificationService: Showing notification - Title: "$title", Body: "$body"',
    );

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'Default Notifications',
          channelDescription:
              'This channel is used for important notifications from Firebase',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher', // Explicitly set icon
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    // Use timestamp as unique ID so multiple notifications can appear
    final int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(
      100000,
    );

    // Convert payload Map to String if provided
    String? payloadString;
    if (payload != null) {
      payloadString = payload.toString(); // Simple string representation
    }

    try {
      await _notifications.show(
        notificationId,
        title,
        body,
        notificationDetails,
        payload: payloadString,
      );
      print(
        '🔔 LocalNotificationService: Notification displayed successfully (ID: $notificationId)',
      );
    } catch (e) {
      print('❌ LocalNotificationService: Error showing notification: $e');
    }
  }
}
