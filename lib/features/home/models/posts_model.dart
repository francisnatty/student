class PostModel {
  final List<Post> data;

  PostModel({required this.data});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      data: (json['data'] as List).map((item) => Post.fromJson(item)).toList(),
    );
  }
}

class Post {
  final int id;
  final String postType;
  final String userId;
  final String title;
  final String subtitle;
  final String content;
  final String? longitude;
  final String? latitude;
  final String? link;
  final String? status;
  final String createdAt;
  final String updatedAt;
  String totalFeedLikes;
  final User user;
  final Poll? poll;
  final List<FileUpload> fileUploads;
  final List<CommentOnFeed> comments;
  final List<LikeOnFeed> likes;
  bool isLiked;

  Post({
    required this.id,
    required this.postType,
    required this.userId,
    required this.title,
    required this.subtitle,
    required this.content,
    this.longitude,
    this.latitude,
    this.link,
    this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.totalFeedLikes,
    required this.user,
    this.poll,
    required this.fileUploads,
    required this.comments,
    required this.likes,
    this.isLiked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      postType: json['postType'],
      userId: json['userId'],
      title: json['title'],
      subtitle: json['subtitle'],
      content: json['content'],
      longitude: json['longitude'],
      latitude: json['lagtitude'], // Note the typo in "latitude"
      link: json['link'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      totalFeedLikes: json['totalFeedLikes'],
      user: User.fromJson(json['User']),
      poll: json['Poll'] != null ? Poll.fromJson(json['Poll']) : null,
      fileUploads: (json['FileUploads'] as List)
          .map((item) => FileUpload.fromJson(item))
          .toList(),
      comments: (json['CommentOnFeeds'] as List)
          .map((item) => CommentOnFeed.fromJson(item))
          .toList(),
      likes: (json['LikeOnFeeds'] as List)
          .map((item) => LikeOnFeed.fromJson(item))
          .toList(),
    );
  }

  void updateIsLiked(String currentUserId) {
    isLiked = likes.any((like) => like.userId.toString() == currentUserId);
  }
}

class User {
  final String firstName;
  final String lastName;
  final String profileImage;

  User({
    required this.firstName,
    required this.lastName,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      lastName: json['last_name'],
      profileImage: json['profile_image'],
    );
  }
}

class Poll {
  // Define fields if Poll has a structure
  Poll();

  factory Poll.fromJson(Map<String, dynamic> json) {
    // Implement parsing logic if Poll exists
    return Poll();
  }
}

class FileUpload {
  final int fileId;
  final String secureUrl;
  final String normalUrl;
  final String fileType;

  FileUpload({
    required this.fileId,
    required this.secureUrl,
    required this.normalUrl,
    required this.fileType,
  });

  factory FileUpload.fromJson(Map<String, dynamic> json) {
    return FileUpload(
      fileId: json['fileId'],
      secureUrl: json['secure_url'],
      normalUrl: json['normal_url'],
      fileType: json['file_type'],
    );
  }
}

class CommentOnFeed {
  final int id;
  final String feedId;
  final String comment;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final String totalCommentLikes;

  CommentOnFeed({
    required this.id,
    required this.feedId,
    required this.comment,
    this.status,
    this.createdAt,
    this.updatedAt,
    required this.totalCommentLikes,
  });

  factory CommentOnFeed.fromJson(Map<String, dynamic> json) {
    return CommentOnFeed(
      id: json['id'],
      feedId: json['feedId'],
      comment: json['comment'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      totalCommentLikes: json['totalCommentLikes'],
    );
  }
}

class LikeOnFeed {
  final int userId;

  LikeOnFeed({required this.userId});

  factory LikeOnFeed.fromJson(Map<String, dynamic> json) {
    return LikeOnFeed(userId: json['userId']);
  }
}
