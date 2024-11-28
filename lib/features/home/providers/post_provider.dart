// lib/providers/posts_provider.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_centric_app/core/network/api_service.dart';
import 'package:dio/dio.dart';
import 'package:student_centric_app/features/home/models/posts_model.dart';

class PostsProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _isFetching = false;
  bool _isPosting = false;
  String? _fetchErrorMessage;
  String? _postErrorMessage;
  String? _postSuccessMessage;

  List<Post> get posts => _posts;
  bool get isFetching => _isFetching;
  bool get isPosting => _isPosting;
  String? get fetchErrorMessage => _fetchErrorMessage;
  String? get postErrorMessage => _postErrorMessage;
  String? get postSuccessMessage => _postSuccessMessage;

  /// Fetches the home feed posts from the API.
  Future<void> fetchHomeFeed() async {
    _isFetching = true;
    _fetchErrorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.instance.get(
        "/datas/fetch/homefeed",
        showBanner: true,
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        if (data['error'] == false) {
          List<Post> fetchedPosts = [];
          print(data['data']);
          for (var postJson in data['data']) {
            fetchedPosts.add(Post.fromJson(postJson));
          }
          print("POSTS HERE: ${fetchedPosts[0].imageUrlOne}");

          _posts = fetchedPosts;
          _fetchErrorMessage = null;
          notifyListeners();
        } else {
          _fetchErrorMessage = data['msg'] ?? 'Failed to fetch posts';
        }
      } else {
        _fetchErrorMessage = 'Failed to fetch posts';
      }
    } catch (e) {
      _fetchErrorMessage = 'An error occurred: $e';
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  /// Posts a new feed to the API.
  ///
  /// [postType], [userId], [content], etc. correspond to the API's expected fields.
  /// File parameters should be provided as [File] objects.
  Future<void> postToFeed({
    required String postType,
    required String userId,
    String? content,
    File? imageUrlOne,
    File? imageUrlTwo,
    File? imageUrlThree,
    File? imageUrlFour,
    File? videoUrlOne,
    File? videoUrlTwo,
    File? videoUrlThree,
    File? videoUrlFour,
    String? longitude,
    String? latitude,
    String? pollTypeTitle,
    String? pollAnswer,
    File? voiceNoteUrl,
  }) async {
    _isPosting = true;
    _postErrorMessage = null;
    _postSuccessMessage = null;
    notifyListeners();

    try {
      Map<String, dynamic> formDataMap = {
        'postType': postType,
        'userId': userId,
        'content': content ?? '',
        'lagtitude': longitude ?? '',
        'latitude': latitude ?? '',
        'pollTypeTitle': pollTypeTitle ?? '',
        'pollAnswer': pollAnswer ?? '',
      };

      // Attach files if they are provided
      if (imageUrlOne != null) {
        formDataMap['imageUrlOne'] = await MultipartFile.fromFile(
          imageUrlOne.path,
          filename: imageUrlOne.path.split('/').last,
        );
      }
      if (imageUrlTwo != null) {
        formDataMap['imageUrlTwo'] = await MultipartFile.fromFile(
          imageUrlTwo.path,
          filename: imageUrlTwo.path.split('/').last,
        );
      }
      if (imageUrlThree != null) {
        formDataMap['imageUrlThree'] = await MultipartFile.fromFile(
          imageUrlThree.path,
          filename: imageUrlThree.path.split('/').last,
        );
      }
      if (imageUrlFour != null) {
        formDataMap['imageUrlFour'] = await MultipartFile.fromFile(
          imageUrlFour.path,
          filename: imageUrlFour.path.split('/').last,
        );
      }
      if (videoUrlOne != null) {
        formDataMap['videoUrlOne'] = await MultipartFile.fromFile(
          videoUrlOne.path,
          filename: videoUrlOne.path.split('/').last,
        );
      }
      if (videoUrlTwo != null) {
        formDataMap['videoUrlTwo'] = await MultipartFile.fromFile(
          videoUrlTwo.path,
          filename: videoUrlTwo.path.split('/').last,
        );
      }
      if (videoUrlThree != null) {
        formDataMap['videoUrlThree'] = await MultipartFile.fromFile(
          videoUrlThree.path,
          filename: videoUrlThree.path.split('/').last,
        );
      }
      if (videoUrlFour != null) {
        formDataMap['videoUrlFour'] = await MultipartFile.fromFile(
          videoUrlFour.path,
          filename: videoUrlFour.path.split('/').last,
        );
      }
      if (voiceNoteUrl != null) {
        formDataMap['voiceNoteUrl'] = await MultipartFile.fromFile(
          voiceNoteUrl.path,
          filename: voiceNoteUrl.path.split('/').last,
        );
      }

      FormData formData = FormData.fromMap(formDataMap);

      final response = await ApiService.instance.post(
        "/datas/home/postToFeed",
        data: formData,
        isProtected: true, // Assuming authentication is required
        isMultipart: true,
        showBanner: true,
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        if (data['error'] == false) {
          _postSuccessMessage = data['msg'] ?? 'Post created successfully';
          // Optionally, you can fetch the updated feed
          await fetchHomeFeed();
        } else {
          _postErrorMessage = data['msg'] ?? 'Failed to create post';
        }
      } else {
        _postErrorMessage = 'Failed to create post';
      }
    } catch (e) {
      _postErrorMessage = 'An error occurred: $e';
    } finally {
      _isPosting = false;
      notifyListeners();
    }
  }

  /// Resets the posts and related states.
  void reset() {
    _posts = [];
    _isFetching = false;
    _isPosting = false;
    _fetchErrorMessage = null;
    _postErrorMessage = null;
    _postSuccessMessage = null;
    notifyListeners();
  }
}
