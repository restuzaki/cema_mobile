import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cema_mobile/app/service/authenticated_client.dart'; // 1. Use friend's code
import 'package:cema_mobile/app/service/local_notification_service.dart'; // 2. Use display code

class NotificationService {
  final AuthenticatedClient _client = AuthenticatedClient();

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ FCM_DEBUG: User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('⚠️ FCM_DEBUG: User granted provisional permission');
    } else {
      print('❌ FCM_DEBUG: User declined or has not accepted permission');
    }
  }

  /// 🔔 NEW: Manual method to get FCM token with detailed debugging
  Future<String?> getTokenWithDebug() async {
    try {
      print('🔍 FCM_DEBUG: Attempting to get FCM token...');

      // Check if Firebase is initialized
      print('🔍 FCM_DEBUG: Firebase initialized, requesting token...');

      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        print('✅ FCM_DEBUG: Token successfully retrieved!');
        print('🔑 FCM_TOKEN: $token');
        return token;
      } else {
        print('❌ FCM_DEBUG: Token is NULL. Possible reasons:');
        print('   1. Running on emulator without Google Play Services');
        print('   2. No internet connection');
        print('   3. Google Services not properly configured');
        print('   4. Token not yet generated (try waiting a few seconds)');
        return null;
      }
    } catch (e, stackTrace) {
      print('❌ FCM_DEBUG: Error getting token: $e');
      print('📍 FCM_DEBUG: Stack trace: $stackTrace');
      return null;
    }
  }

  /// 🔔 NEW: Setup token refresh listener
  void setupTokenRefreshListener() {
    print('🔍 FCM_DEBUG: Setting up token refresh listener...');

    FirebaseMessaging.instance.onTokenRefresh.listen(
      (newToken) {
        print('🔄 FCM_DEBUG: Token refreshed!');
        print('🔑 FCM_NEW_TOKEN: $newToken');

        // Automatically sync the new token with backend
        syncTokenDirectly(newToken);
      },
      onError: (error) {
        print('❌ FCM_DEBUG: Error in token refresh listener: $error');
      },
    );

    print('✅ FCM_DEBUG: Token refresh listener setup complete');
  }

  /// This function links your FCM Token to your Backend
  Future<void> syncToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await syncTokenDirectly(token);
      } else {
        print('⚠️ FCM_DEBUG: Cannot sync token - token is null');
      }
    } catch (e) {
      print("❌ FCM_DEBUG: Error syncing token: $e");
    }
  }

  /// 🔔 NEW: Sync a specific token to backend
  Future<void> syncTokenDirectly(String token) async {
    try {
      print('🔄 FCM_DEBUG: Syncing token to backend...');

      // We use your friend's post method - it handles Auth & BaseURL automatically!
      final response = await _client.post(
        Uri.parse("${_client.baseUrl}/user/update-fcm-token"),
        body: jsonEncode({'fcm_token': token}),
      );
      _client.processResponse(response);

      print("✅ FCM_DEBUG: Token synced with backend successfully");
    } catch (e) {
      print("❌ FCM_DEBUG: Error syncing token to backend: $e");
    }
  }

  /// This listener ensures notifications show up while the app is OPEN
  void listenForeground() {
    print('🔍 FCM_DEBUG: Setting up foreground message listener...');

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("🔔 FCM_DEBUG: Notification received in foreground!");
        print("📱 FCM_DEBUG: Message ID: ${message.messageId}");
        print("📱 FCM_DEBUG: Data: ${message.data}");

        if (message.notification != null) {
          print("📱 FCM_DEBUG: Title: ${message.notification!.title}");
          print("📱 FCM_DEBUG: Body: ${message.notification!.body}");

          LocalNotificationService.show(
            title: message.notification!.title ?? "No Title",
            body: message.notification!.body ?? "No Body",
          );
        } else {
          print("⚠️ FCM_DEBUG: Message has no notification payload");
        }
      },
      onError: (error) {
        print('❌ FCM_DEBUG: Error in foreground listener: $error');
      },
    );

    print('✅ FCM_DEBUG: Foreground message listener setup complete');
  }
}
