class SupportMessage {
  final String name;
  final String email; // Pastikan ini ada
  final String subject; // Pastikan ini ada
  final String message;
  final DateTime createdAt;

  SupportMessage({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'subject': subject,
    'message': message,
    'createdAt': createdAt.toIso8601String(),
  };

  factory SupportMessage.fromJson(Map<String, dynamic> json) => SupportMessage(
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    subject: json['subject'] ?? '',
    message: json['message'] ?? '',
    createdAt: DateTime.parse(json['createdAt']),
  );
}
