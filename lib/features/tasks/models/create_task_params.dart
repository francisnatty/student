import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class CreateTaskParams {
  final List<File> files;
  final String userId;
  final String title;
  final String startTime;
  final String endTime;
  final String timeZone;
  final bool videoConferencing;
  final String location;
  final String description;
  final List<String> participants;
  final bool repeat;

  CreateTaskParams({
    required this.files,
    required this.userId,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.timeZone,
    required this.videoConferencing,
    required this.location,
    required this.description,
    required this.participants,
    required this.repeat,
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'files': await Future.wait(
        files.map(
          (file) async => await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last),
        ),
      ),
      'user_id': userId,
      'title': title.trim(),
      'startTime': startTime.trim(),
      'endTime': endTime.trim(),
      'timeZone': timeZone.trim(),
      'videoConferencing': videoConferencing.toString(),
      'location': location.trim(),
      'description': description.trim(),
      'participants': participants,
      'repeat': repeat.toString(),
    });
  }
}
