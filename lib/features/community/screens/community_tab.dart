// community_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/features/home/providers/post_provider.dart';
import 'package:student_centric_app/features/home/widgets/feed_posts_container.dart';

class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostsProvider>(
      builder: (context, postsProvider, child) {
        final posts = postsProvider.posts;
        final isLoading = postsProvider.isFetching;

        if (isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (posts.isEmpty) {
          return Center(
            child: Text(
              "No feeds available",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Optional: Add a section title if needed
                Text(
                  'Community Feed',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.h),
                // Dynamically display posts
                ...posts.map((post) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: FeedPostsContainer(
                      userName:
                          "${post.user?.firstName ?? 'Default'} ${post.user?.lastName ?? 'User'}",
                      timeAgo: "Just Now", // Adjust as needed
                      postContent: post.content ?? "",
                      images: [
                        if (post.imageUrlOne != null) post.imageUrlOne!,
                        if (post.imageUrlTwo != null) post.imageUrlTwo!,
                        if (post.imageUrlThree != null) post.imageUrlThree!,
                        if (post.imageUrlFour != null) post.imageUrlFour!,
                      ],
                      videos: [
                        if (post.videoUrlOne != null) post.videoUrlOne!,
                        if (post.videoUrlTwo != null) post.videoUrlTwo!,
                        if (post.videoUrlThree != null) post.videoUrlThree!,
                        if (post.videoUrlFour != null) post.videoUrlFour!,
                      ],
                      pollTypeTitle: post.pollTypeTitle,
                      pollAnswers: post.pollAnswer?.split(","),
                      voiceNoteUrl: post.voiceNoteUrl,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
