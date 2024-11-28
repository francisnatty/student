// lib/models/post.dart
import 'dart:convert';

class Post {
  final int id;
  final String postType;
  final String userId;
  final String content;
  final String? imageUrlOne;
  final String? imageUrlTwo;
  final String? imageUrlThree;
  final String? imageUrlFour;
  final String? videoUrlOne;
  final String? videoUrlTwo;
  final String? videoUrlThree;
  final String? videoUrlFour;
  final String longitude;
  final String? latitude; // Made nullable to handle potential nulls
  final String? pollTypeTitle;
  final String? pollAnswer;
  final String? voiceNoteUrl;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User user;

  Post({
    required this.id,
    required this.postType,
    required this.userId,
    required this.content,
    this.imageUrlOne,
    this.imageUrlTwo,
    this.imageUrlThree,
    this.imageUrlFour,
    this.videoUrlOne,
    this.videoUrlTwo,
    this.videoUrlThree,
    this.videoUrlFour,
    required this.longitude,
    this.latitude, // Updated to nullable
    this.pollTypeTitle,
    this.pollAnswer,
    this.voiceNoteUrl,
    required this.status,
    this.createdAt,
    this.updatedAt,
    required this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      postType: json['postType'] ?? '',
      userId: json['userId'] ?? '',
      content: json['content'] ?? '',
      imageUrlOne: json['imageUrlOne'],
      imageUrlTwo: json['imageUrlTwo'],
      imageUrlThree: json['imageUrlThree'],
      imageUrlFour: json['imageUrlFour'],
      videoUrlOne: json['videoUrlOne'],
      videoUrlTwo: json['videoUrlTwo'],
      videoUrlThree: json['videoUrlThree'],
      videoUrlFour: json['videoUrlFour'],
      longitude: json['longitude'] ?? '',
      latitude:
          json['lagtitude'], // Corrected key from 'latitude' to 'lagtitude'
      pollTypeTitle: json['pollTypeTitle'],
      pollAnswer: json['pollAnswer'],
      voiceNoteUrl: json['voiceNoteUrl'],
      status: json['status'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      user: json["User"] != null
          ? User.fromJson(json["User"])
          : User(firstName: "Unknown", lastName: "User"),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postType': postType,
      'userId': userId,
      'content': content,
      'imageUrlOne': imageUrlOne,
      'imageUrlTwo': imageUrlTwo,
      'imageUrlThree': imageUrlThree,
      'imageUrlFour': imageUrlFour,
      'videoUrlOne': videoUrlOne,
      'videoUrlTwo': videoUrlTwo,
      'videoUrlThree': videoUrlThree,
      'videoUrlFour': videoUrlFour,
      'longitude': longitude,
      'lagtitude': latitude, // Ensure consistency with API's expected key
      'pollTypeTitle': pollTypeTitle,
      'pollAnswer': pollAnswer,
      'voiceNoteUrl': voiceNoteUrl,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      "User": user.toJson(),
    };
  }
}

class User {
  final String firstName;
  final String lastName;

  User({
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["first_name"] ?? "First",
        lastName: json["last_name"] ?? "Last",
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
      };
}
