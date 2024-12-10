import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/home/widgets/video_player.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FeedPostsContainer extends StatelessWidget {
  final String userName;
  final String timeAgo;
  final String postContent;
  final List<String> images;
  final List<String> videos;
  final String? pollTypeTitle;
  final List<String>? pollAnswers;
  final String? voiceNoteUrl;
  final bool ispostLiked;

  const FeedPostsContainer({
    super.key,
    required this.userName,
    required this.timeAgo,
    required this.postContent,
    this.images = const [],
    this.videos = const [],
    this.pollTypeTitle,
    this.pollAnswers,
    this.voiceNoteUrl,
    required this.ispostLiked,
  });

  @override
  Widget build(BuildContext context) {
    // Combine images and videos into a single list for the carousel
    final mediaItems = [...images, ...videos];
    final bool hasMultipleMedia = mediaItems.length > 1;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Row
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                child: SvgPicture.asset(
                  AppAssets.profileIcon,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              // SvgPicture.asset(
              //   AppAssets.moreHoriz,
              //   height: 20.h,
              // ),
            ],
          ),
          SizedBox(height: 14.h),
          // Post Content
          Text(
            postContent,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 14.h),

          // Media: Images and Videos with Page Indicator
          if (mediaItems.isNotEmpty) MediaCarousel(mediaItems: mediaItems),

          // Poll Section
          if (pollTypeTitle != null && pollAnswers != null)
            Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pollTypeTitle!,
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  ...pollAnswers!.map((answer) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.radio_button_unchecked,
                              size: 16.sp,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                answer,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),

          // Voice Note Section
          if (voiceNoteUrl != null)
            Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: Row(
                children: [
                  Icon(Icons.mic, color: Colors.grey, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    "Voice Note Available",
                    style:
                        TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

          SizedBox(height: 14.h),
          // Interaction Row

          SizedBox(height: 10.h),
          Row(
            children: [
              Row(
                children: [
                  ispostLiked
                      ? SvgPicture.asset(
                          AppAssets.likeIcon,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primaryColor,
                            BlendMode.srcIn,
                          ),
                          height: 20.h,
                          width: 20.w,
                        )
                      : SvgPicture.asset(
                          AppAssets.likeIcon,
                          height: 20.h,
                          width: 20.w,
                        ),
                  SizedBox(width: 6.w),
                  Text(
                    "Like",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
              SizedBox(width: 24.w),
              Row(
                children: [
                  SvgPicture.asset(
                    AppAssets.messageIcon,
                    height: 20.h,
                    width: 20.w,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "Comment",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MediaCarousel extends StatefulWidget {
  final List<String> mediaItems;

  const MediaCarousel({super.key, required this.mediaItems});

  @override
  _MediaCarouselState createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  bool _isVideo(String url) {
    // Simple check based on file extension
    final videoExtensions = ['mp4', 'avi', 'mov', 'wmv', 'flv', 'mkv'];
    final extension = url.split('.').last.toLowerCase();
    return videoExtensions.contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.mediaItems.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final mediaUrl = widget.mediaItems[index];
              if (_isVideo(mediaUrl)) {
                return VideoPlayerWidget(videoUrl: mediaUrl);
              } else {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: Image.network(
                    mediaUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }
            },
          ),
        ),
        if (widget.mediaItems.length > 1)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: widget.mediaItems.length,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.primaryColor,
                dotHeight: 8.h,
                dotWidth: 8.w,
                spacing: 4.w,
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
