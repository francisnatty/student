import 'dart:convert';

class GetChatHistoryModel {
  final List<Data> data;
  final bool error;
  final String msg;

  GetChatHistoryModel({
    required this.data,
    required this.error,
    required this.msg,
  });

  factory GetChatHistoryModel.fromJson(Map<String, dynamic> json) {
    return GetChatHistoryModel(
      data: List<Data>.from(json['data'].map((x) => Data.fromJson(x))),
      error: json['error'],
      msg: json['msg'],
    );
  }
}

class Data {
  final User user;

  final LastMessage lastMessage;

  Data({
    required this.user,
    required this.lastMessage,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      user: User.fromJson(json['user']),
      lastMessage: LastMessage.fromJson(json['last_message']),
    );
  }
}

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String firebaseToken;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.firebaseToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      firebaseToken: json['firebaseToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'firebaseToken': firebaseToken,
    };
  }
}

class LastMessage {
  final String message;
  final DateTime createdAt;
  final String senderId;
  final String receiverId;
  final String messageId;
  final String lastChatTime;

  LastMessage({
    required this.message,
    required this.createdAt,
    required this.senderId,
    required this.receiverId,
    required this.messageId,
    required this.lastChatTime,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      messageId: json['messageId'],
      lastChatTime: json['last_chat_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'senderId': senderId,
      'receiverId': receiverId,
      'messageId': messageId,
      'last_chat_time': lastChatTime,
    };
  }
}
