import 'package:get/get.dart';
import '../notification_model.dart';

class NotificationController extends GetxController {
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
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
}
