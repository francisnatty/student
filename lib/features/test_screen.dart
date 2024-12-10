import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_centric_app/config/service_locator.dart';
import 'package:student_centric_app/core/utils/debug_logger.dart';
import 'package:student_centric_app/features/home/data/home_service.dart';
import 'package:student_centric_app/features/home/models/create_feeds_params.dart';
import 'package:student_centric_app/features/home/models/posts_model.dart';

import '../core/storage/local_storage.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  File? selectedImage;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        // feedParams.file = selectedImage; // Assign selected image to the params
      });
    }
  }

  Future<void> getData() async {
    final localStorage = Di.getIt<LocalStorage>();
    String? token = await localStorage.getAcessToken();

    var headers = {'Authorization': 'Bearer $token'};
    print('calling');
    var dio = Dio();
    var response = await dio.request(
      'https://typescript-boilerplate.onrender.com/api/v1/datas/fetch/homefeed',
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    );
    print(response.data);

    if (response.statusCode == 200) {
      var post = PostModel.fromJson(response.data);
    } else {
      print(response.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              pickImage();
            },
            child: const Text('PickImage'),
          ),
          ElevatedButton(
            onPressed: () async {
              getData();
              final homeService = Di.getIt<HomeService>();
              final CreateFeedsParams feedParams = CreateFeedsParams(
                title: 'Hello',
                subtitle: 'This is a subtitle',
                postType: 'feed',
                content: 'Sample content',
                latitude: '1222',
                longitude: '443',
                pollTypeTitle: '',
                pollAnswer: '',
                file: selectedImage,
              );

              //  var response = await homeService.createFeed(params: feedParams);G
              var response = await homeService.getFeeds();

              DebugLogger.log(
                'response',
                response.rawJson,
              );
              // getData();
            },
            child: const Text(
              'SEND REQUEST',
            ),
          )
        ],
      ),
    );
  }
}
