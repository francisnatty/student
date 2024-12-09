import 'dart:io';

import 'package:dio/dio.dart';

class CreateFeedsParams {
  File? file;
  String? title;
  String? subtitle;
  String? postType;
  String? content;
  String? latitude;
  String? longitude;
  String? pollTypeTitle;
  String? pollAnswer;

  CreateFeedsParams({
    this.file,
    this.title,
    this.subtitle,
    this.postType,
    this.content,
    this.latitude,
    this.longitude,
    this.pollTypeTitle,
    this.pollAnswer,
  });

  // Method to generate FormData for an API request
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      if (file != null)
        'fileUpload': file != null
            ? await MultipartFile.fromFile(
                file!.path,
                filename: file!.path.split('/').last,
              )
            : null,
      'title': title,
      'subtitle': subtitle,
      'postType': postType,
      'content': content,
      'latitude': latitude,
      'longitude': longitude,
      'pollTypeTitle': pollTypeTitle,
      'pollAnswer': pollAnswer,
    });
  }
}
