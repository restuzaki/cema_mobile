import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cema_mobile/app/service/authenticated_client.dart'; // 1. Use friend's code
import 'package:cema_mobile/app/service/local_notification_service.dart'; // 2. Use display code

class NotificationService {
  final AuthenticatedClient _client = AuthenticatedClient();

  Future<void> requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<String?> getTokenWithDebug() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        print('FCM_TOKEN: $token');
        return token;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  void setupTokenRefreshListener() {
    FirebaseMessaging.instance.onTokenRefresh.listen(
      (newToken) {
        print('FCM_NEW_TOKEN: $newToken');
        syncTokenDirectly(newToken);
      },
      onError: (error) {
        print('Error in token refresh listener: $error');
      },
    );
  }

  Future<void> syncToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await syncTokenDirectly(token);
      }
    } catch (e) {
      print("Error syncing token: $e");
    }
  }

  Future<void> syncTokenDirectly(String token) async {
    try {
      final response = await _client.post(
        Uri.parse("${_client.baseUrl}/user/update-fcm-token"),
        body: jsonEncode({'fcm_token': token}),
      );
      _client.processResponse(response);
    } catch (e) {
      print("Error syncing token to backend: $e");
    }
  }

  void listenForeground() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        if (message.notification != null) {
          LocalNotificationService.show(
            title: message.notification!.title ?? "No Title",
            body: message.notification!.body ?? "No Body",
          );
        }
      },
      onError: (error) {
        print('Error in foreground listener: $error');
      },
    );
  }
}
