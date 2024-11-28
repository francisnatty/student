// lib/models/chat_user.dart
class ChatUser {
  final int id;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? firebaseToken;

  ChatUser({
    required this.id,
    this.firstName,
    this.lastName,
    required this.email,
    this.firebaseToken,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      firebaseToken: json['firebaseToken'],
    );
  }
}
