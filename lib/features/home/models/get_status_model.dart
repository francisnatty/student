class GetStatusModel {
  final List<StatusData> data;
  final bool error;
  final String msg;

  GetStatusModel({
    required this.data,
    required this.error,
    required this.msg,
  });

  factory GetStatusModel.fromJson(Map<String, dynamic> json) {
    return GetStatusModel(
      data: (json['data'] as List)
          .map((item) => StatusData.fromJson(item))
          .toList(),
      error: json['error'],
      msg: json['msg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'error': error,
      'msg': msg,
    };
  }
}

class StatusData {
  final int id;
  final String postType;
  final String status;
  final DateTime createdAt;
  final List<FileUpload> fileUploads;

  StatusData({
    required this.id,
    required this.postType,
    required this.status,
    required this.createdAt,
    required this.fileUploads,
  });

  factory StatusData.fromJson(Map<String, dynamic> json) {
    return StatusData(
      id: json['id'],
      postType: json['postType'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      fileUploads: (json['FileUploads'] as List)
          .map((item) => FileUpload.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postType': postType,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'FileUploads': fileUploads.map((item) => item.toJson()).toList(),
    };
  }
}

class FileUpload {
  final String secureUrl;
  final String normalUrl;
  final String fileType;

  FileUpload({
    required this.secureUrl,
    required this.normalUrl,
    required this.fileType,
  });

  factory FileUpload.fromJson(Map<String, dynamic> json) {
    return FileUpload(
      secureUrl: json['secure_url'],
      normalUrl: json['normal_url'],
      fileType: json['file_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'secure_url': secureUrl,
      'normal_url': normalUrl,
      'file_type': fileType,
    };
  }
}
