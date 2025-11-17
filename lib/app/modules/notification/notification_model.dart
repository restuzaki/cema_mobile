class NotificationItem {
  final String title;
  final String subtitle;
  final String? amount;
  final bool hasAction;
  final String timestamp;
  final List<String>? avatars;

  NotificationItem({
    required this.title,
    required this.subtitle,
    this.amount,
    this.hasAction = false,
    required this.timestamp,
    this.avatars,
  });
}
