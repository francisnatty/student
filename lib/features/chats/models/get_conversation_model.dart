import 'dart:convert';

class GetConversationModel {
  final List<ChatMessage> data;
  final bool error;
  final String msg;

  GetConversationModel({
    required this.data,
    required this.error,
    required this.msg,
  });

  factory GetConversationModel.fromJson(Map<String, dynamic> json) {
    return GetConversationModel(
      data: List<ChatMessage>.from(
          json['data'].map((x) => ChatMessage.fromJson(x))),
      error: json['error'],
      msg: json['msg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((x) => x.toJson()).toList(),
      'error': error,
      'msg': msg,
    };
  }
}

class ChatMessage {
  final String message;
  final String createdAt;
  final String senderId;
  final String receiverId;
  final String messageId;

  ChatMessage({
    required this.message,
    required this.createdAt,
    required this.senderId,
    required this.receiverId,
    required this.messageId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'],
      createdAt: json['createdAt'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      messageId: json['messageId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'createdAt': createdAt,
      'senderId': senderId,
      'receiverId': receiverId,
      'messageId': messageId,
    };
  }
}
