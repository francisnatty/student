import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_centric_app/config/service_locator.dart';
import 'package:student_centric_app/core/utils/debug_logger.dart';
import 'package:student_centric_app/features/home/data/home_service.dart';
import 'package:student_centric_app/features/home/models/create_feeds_params.dart';

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
            child: Text('PickImage'),
          ),
          ElevatedButton(
            onPressed: () async {
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

              var response = await homeService.createFeed(params: feedParams);
              DebugLogger.log(
                'response',
                response.rawJson,
              );
            },
            child: Text(
              'SEND REQUEST',
            ),
          )
        ],
      ),
    );
  }
}
