class NotificationItem {
  final String title;
  final String subtitle;
  final String? amount;
  final bool hasAction;
  final String timestamp;
  final List<String>? avatars;
  final String? taskId;
  final String? expenseId;

  NotificationItem({
    required this.title,
    required this.subtitle,
    this.amount,
    this.hasAction = false,
    required this.timestamp,
    this.avatars,
    this.taskId,
    this.expenseId,
  });
}
