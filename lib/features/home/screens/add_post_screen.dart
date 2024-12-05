import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/core/extensions/account_extension.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/home/providers/post_provider.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _pollChoice1Controller = TextEditingController();
  final TextEditingController _pollChoice2Controller = TextEditingController();
  bool isPollAdded = false;
  List<File> _selectedImages = [];
  List<File> _selectedVideos = [];
  File? _selectedVoiceNote;

  final int maxMediaCount = 4;
  int? selectedIndex = 0;
  final List<String> postItemList = [
    "Post to feed",
    "Post to community",
    "Post to status"
  ];

  Future<void> _pickMedia({required bool isImage}) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: isImage ? ImageSource.gallery : ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        if (isImage && _selectedImages.length < maxMediaCount) {
          _selectedImages.add(File(pickedFile.path));
        } else if (!isImage && _selectedVideos.length < maxMediaCount) {
          _selectedVideos.add(File(pickedFile.path));
        }
      });
    }
  }

  Future<void> _pickVoiceNote() async {
    // Replace this with your preferred audio picker
    final XFile? voiceNote = await ImagePicker()
        .pickVideo(source: ImageSource.gallery); // Placeholder
    if (voiceNote != null) {
      setState(() {
        _selectedVoiceNote = File(voiceNote.path);
      });
    }
  }

  Future<void> _postToFeed() async {
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    debugPrint("selected post Type => ${selectedIndex}");
    await postsProvider.postToFeed(
      postType: (selectedIndex == 0)
          ? PostTypeEnums.feed.name
          : (selectedIndex == 1)
              ? PostTypeEnums.community.name
              : PostTypeEnums.status.name, // Example post type
      userId: context.account.user!.id
          .toString(), // Replace with the actual user ID
      content: _contentController.text,
      imageUrlOne: _selectedImages.isNotEmpty ? _selectedImages[0] : null,
      imageUrlTwo: _selectedImages.length > 1 ? _selectedImages[1] : null,
      imageUrlThree: _selectedImages.length > 2 ? _selectedImages[2] : null,
      imageUrlFour: _selectedImages.length > 3 ? _selectedImages[3] : null,
      videoUrlOne: _selectedVideos.isNotEmpty ? _selectedVideos[0] : null,
      videoUrlTwo: _selectedVideos.length > 1 ? _selectedVideos[1] : null,
      videoUrlThree: _selectedVideos.length > 2 ? _selectedVideos[2] : null,
      videoUrlFour: _selectedVideos.length > 3 ? _selectedVideos[3] : null,
      pollTypeTitle: isPollAdded ? 'Poll Title' : null,
      pollAnswer: isPollAdded
          ? '${_pollChoice1Controller.text},${_pollChoice2Controller.text}'
          : null,
      voiceNoteUrl: _selectedVoiceNote,
    );

    if (postsProvider.postErrorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(postsProvider.postErrorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              postsProvider.postSuccessMessage ?? 'Post created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Optionally close the screen after posting
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPosting = Provider.of<PostsProvider>(context).isPosting;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.grey1,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "New Post",
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.blackThree,
          ),
        ),
        leading: IconButton(
          icon: CircleAvatar(
            radius: 24.r,
            child: const Icon(
              Icons.arrow_back,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                itemCount: postItemList.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: AppColors.grey1,
                        border: Border.all(
                          color: AppColors.grey1,
                        ),
                        borderRadius: BorderRadius.circular(
                          16.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          postItemList[index],
                          style: TextStyle(
                            color: selectedIndex == index
                                ? AppColors.primaryColor
                                : Colors.black,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            10.verticalSpace,
            (selectedIndex == 0) ? Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  child: SvgPicture.asset(
                    AppAssets.profileIcon,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "${context.account.user!.firstName} ${context.account.user!.lastName}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ):Container(),
            const SizedBox(height: 16),
            (selectedIndex == 0) ? _postToFeedWidget() : _postToStatusWidget(),
            const SizedBox(height: 32),
            (selectedIndex == 0) ? AppButton.primary(
              text: "Post",
              onPressed: isPosting ? null : _postToFeed,
              isLoading: isPosting,
            ):
            Container()
          ],
        ).padHorizontal,
      ),
    );
  }

  Widget _postToFeedWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyTwo),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: TextField(
              controller: _contentController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Start typing...',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
          if (_selectedImages.isNotEmpty || _selectedVideos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._selectedImages.map((image) => Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.file(image,
                              height: 100, width: 100, fit: BoxFit.cover),
                          Positioned(
                            top: -8,
                            right: -8,
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _selectedImages.remove(image);
                              }),
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          )
                        ],
                      )),
                  ..._selectedVideos.map((video) => Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.video_library, size: 100),
                          Positioned(
                            top: -8,
                            right: -8,
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _selectedVideos.remove(video);
                              }),
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          if (isPollAdded)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _pollChoice1Controller,
                    decoration: InputDecoration(
                      hintText: 'Choice 1',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _pollChoice2Controller,
                    decoration: InputDecoration(
                      hintText: 'Choice 2',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // Add more poll choices logic
                    },
                    child: const Text('Add another choice'),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isPollAdded = false; // Remove poll
                      });
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.remove_circle, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Remove Poll',
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  AppAssets.galleryIcon,
                  height: 25.h,
                ),
                onPressed: () => _pickMedia(isImage: true),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  AppAssets.videoIcon,
                  height: 25.h,
                ),
                onPressed: () => _pickMedia(isImage: false),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  AppAssets.pollIcon,
                  height: 25.h,
                ),
                onPressed: () {
                  setState(() {
                    isPollAdded = true; // Toggle poll UI
                  });
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  AppAssets.locationIcon,
                  height: 25.h,
                ),
                onPressed: () {
                  // Add location functionality
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  AppAssets.microphoneIcon,
                  height: 25.h,
                ),
                onPressed: _pickVoiceNote,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _postToStatusWidget() {
    return Column(
      children: [
        Container(
          height: 500.h,
          width: 320.w,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyTwo),
              borderRadius: BorderRadius.circular(30),
              image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/status_image.png',
                  ),
                  fit: BoxFit.cover)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 60.h,
              width: 60.w,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyTwo),
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                      image: AssetImage(
                        'assets/images/status_image.png',
                      ),
                      fit: BoxFit.fill)),
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/camera_circle.svg',
                height: 60,
                width: 60,
              ),
              onPressed: () => _pickMedia(isImage: true),
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/text_circle.svg',
                height: 60,
                width: 60,
              ),
              onPressed: () => _pickMedia(isImage: true),
            ),
          ],
        ),
      ],
    );
  }
}
