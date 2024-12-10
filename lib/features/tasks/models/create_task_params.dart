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
    FormData data = FormData();

    // Add fields
    data.fields.add(MapEntry('user_id', userId));
    data.fields.add(MapEntry('title', title));
    data.fields.add(MapEntry('startTime', startTime));
    data.fields.add(MapEntry('endTime', endTime));
    data.fields.add(MapEntry('timeZone', timeZone));
    data.fields
        .add(MapEntry('videoConferencing', videoConferencing.toString()));
    data.fields.add(MapEntry('location', location));
    data.fields.add(MapEntry('description', description));
    data.fields.add(MapEntry('participants', participants.toString()));
    data.fields.add(MapEntry('repeat', repeat.toString()));

    // Add files
    for (final file in files) {
      data.files.add(
        MapEntry(
          'attachments',
          await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last),
        ),
      );
    }

    return data;
  }
}
