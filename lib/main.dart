import 'package:cema_mobile/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // 🔔 TAMBAHAN
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/design_system/design_system.dart';
import 'app/routes/app_pages.dart';

// 🔔 TAMBAHAN
import 'package:cema_mobile/app/service/local_notification_service.dart';
import 'package:cema_mobile/app/service/notification_service.dart';

/// 🔔 TAMBAHAN
/// Handler untuk notifikasi saat app di background / terminated
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
  await LocalNotificationService.init();

  // Connects FCM to LocalNotificationService
  notificationService.listenForeground();

  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
