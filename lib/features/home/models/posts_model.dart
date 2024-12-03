class PostModel {
  List<Post>? data;
  bool? error;
  String? msg;

  PostModel({this.data, this.error, this.msg});

  PostModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Post>[];
      json['data'].forEach((v) {
        data!.add(Post.fromJson(v));
      });
    }
    error = json['error'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    data['msg'] = msg;
    return data;
  }
}

class Post {
  int? id;
  String? postType;
  String? userId;
  String? title;
  String? subtitle;
  String? content;
  String? longitude;
  String? lagtitude;
  String? pollTypeTitle;
  String? pollAnswer;
  String? link;
  String? status;
  String? createdAt;
  String? updatedAt;
  User? user;
  List<Null>? polls;
  List<FileUploads>? fileUploads;
  List<CommentOnFeeds>? commentOnFeeds;
  List<LikeOnFeeds>? likeOnFeeds;

  Post(
      {this.id,
        this.postType,
        this.userId,
        this.title,
        this.subtitle,
        this.content,
        this.longitude,
        this.lagtitude,
        this.pollTypeTitle,
        this.pollAnswer,
        this.link,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.polls,
        this.fileUploads,
        this.commentOnFeeds,
        this.likeOnFeeds});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postType = json['postType'];
    userId = json['userId'];
    title = json['title'];
    subtitle = json['subtitle'];
    content = json['content'];
    longitude = json['longitude'];
    lagtitude = json['lagtitude'];
    pollTypeTitle = json['pollTypeTitle'];
    pollAnswer = json['pollAnswer'];
    link = json['link'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['User'] != null ? User.fromJson(json['User']) : null;
    // if (json['Polls'] != null) {
    //   polls = <Null>[];
    //   json['Polls'].forEach((v) {
    //     polls!.add(Null.fromJson(v));
    //   });
    // }
    if (json['FileUploads'] != null) {
      fileUploads = <FileUploads>[];
      json['FileUploads'].forEach((v) {
        fileUploads!.add(FileUploads.fromJson(v));
      });
    }
    if (json['CommentOnFeeds'] != null) {
      commentOnFeeds = <CommentOnFeeds>[];
      json['CommentOnFeeds'].forEach((v) {
        commentOnFeeds!.add(CommentOnFeeds.fromJson(v));
      });
    }
    if (json['LikeOnFeeds'] != null) {
      likeOnFeeds = <LikeOnFeeds>[];
      json['LikeOnFeeds'].forEach((v) {
        likeOnFeeds!.add(LikeOnFeeds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['postType'] = postType;
    data['userId'] = userId;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['content'] = content;
    data['longitude'] = longitude;
    data['lagtitude'] = lagtitude;
    data['pollTypeTitle'] = pollTypeTitle;
    data['pollAnswer'] = pollAnswer;
    data['link'] = link;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['User'] = user!.toJson();
    }
    // if (polls != null) {
    //   data['Polls'] = polls!.map((v) => v.toJson()).toList();
    // }
    if (fileUploads != null) {
      data['FileUploads'] = fileUploads!.map((v) => v.toJson()).toList();
    }
    if (commentOnFeeds != null) {
      data['CommentOnFeeds'] =
          commentOnFeeds!.map((v) => v.toJson()).toList();
    }
    if (likeOnFeeds != null) {
      data['LikeOnFeeds'] = likeOnFeeds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? firstName;
  String? lastName;

  User({this.firstName, this.lastName});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}

class FileUploads {
  String? secureUrl;
  String? normalUrl;
  String? fileType;

  FileUploads({this.secureUrl, this.normalUrl, this.fileType});

  FileUploads.fromJson(Map<String, dynamic> json) {
    secureUrl = json['secure_url'];
    normalUrl = json['normal_url'];
    fileType = json['file_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secure_url'] = secureUrl;
    data['normal_url'] = normalUrl;
    data['file_type'] = fileType;
    return data;
  }
}

class CommentOnFeeds {
  String? comment;
  List<CommentLikeOnFeeds>? likeOnFeeds;

  CommentOnFeeds({this.comment, this.likeOnFeeds});

  CommentOnFeeds.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    if (json['LikeOnFeeds'] != null) {
      likeOnFeeds = <CommentLikeOnFeeds>[];
      json['LikeOnFeeds'].forEach((v) {
        likeOnFeeds!.add(CommentLikeOnFeeds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = comment;
    if (likeOnFeeds != null) {
      data['LikeOnFeeds'] = likeOnFeeds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentLikeOnFeeds {
  int? commentLike;

  CommentLikeOnFeeds({this.commentLike});

  CommentLikeOnFeeds.fromJson(Map<String, dynamic> json) {
    commentLike = json['commentLike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commentLike'] = commentLike;
    return data;
  }
}

class LikeOnFeeds {
  int? feedLike;

  LikeOnFeeds({this.feedLike});

  LikeOnFeeds.fromJson(Map<String, dynamic> json) {
    feedLike = json['feedLike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['feedLike'] = this.feedLike;
    return data;
  }
}
