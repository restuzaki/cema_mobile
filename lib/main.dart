import 'package:cema_mobile/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/design_system/design_system.dart';
import 'app/routes/app_pages.dart';

import 'package:cema_mobile/app/service/local_notification_service.dart';
import 'package:cema_mobile/app/service/notification_service.dart';

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize NotificationService
  final NotificationService notificationService = NotificationService();

  // Request Permission immediately on startup
  await notificationService.requestPermission();

  // Get token with enhanced debugging
  await notificationService.getTokenWithDebug();

  // Setup token refresh listener to catch token updates
  notificationService.setupTokenRefreshListener();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  await LocalNotificationService.init(
    onNotificationTap: (data) {
      print('🔔 Notification tapped in foreground: $data');
      _handleNotificationNavigation(data);
    },
  );

  // Connects FCM to LocalNotificationService
  notificationService.listenForeground();

  // 🔔 Handle notification tap when app is in background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('🔔 Notification tapped (from background): ${message.data}');
    _handleNotificationNavigation(message.data);
  });

  RemoteMessage? initialMessage = await FirebaseMessaging.instance
      .getInitialMessage();
  if (initialMessage != null) {
    print('App opened from notification (terminated): ${initialMessage.data}');
  }

  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp(initialMessage: initialMessage));
}

/// 🔔 Handle navigation based on notification data
void _handleNotificationNavigation(Map<String, dynamic> data) {
  try {
    final String? type = data['type'];
    final String? id = data['id'];

    print('🔔 Navigating to: type=$type, id=$id');

    if (type == 'project' && id != null) {
      // Navigate to project detail page
      Get.toNamed('/project-detail', arguments: {'projectId': id});
    } else if (type == 'task' && id != null) {
      // Navigate to task detail page
      Get.toNamed('/task-detail', arguments: {'taskId': id});
    } else {
      // Default: just go to notifications page
      Get.toNamed('/notification');
    }
  } catch (e) {
    print('❌ Error handling notification navigation: $e');
  }
}

class MyApp extends StatelessWidget {
  final RemoteMessage? initialMessage;

  const MyApp({super.key, this.initialMessage});

  @override
  Widget build(BuildContext context) {
    // Handle navigation from terminated state after app is ready
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNotificationNavigation(initialMessage!.data);
      });
    }

    return GetMaterialApp(
      navigatorKey: Get.key,
      debugShowCheckedModeBanner: false,
      title: "Cema Mobile",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    );
  }
}
