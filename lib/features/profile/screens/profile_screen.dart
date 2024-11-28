import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/core/extensions/account_extension.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/home/providers/post_provider.dart';
import 'package:student_centric_app/features/home/widgets/feed_posts_container.dart';
import 'package:student_centric_app/features/profile/screens/edit_profile_screen.dart';
import 'package:student_centric_app/widgets/app_button.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        backgroundColor: AppColors.grey1,
        appBar: AppBar(
          backgroundColor: AppColors.grey1,
          elevation: 0,
          // Optional: You can move the back and menu buttons to the AppBar
          leading: IconButton(
            icon: Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.greyTwo,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back,
                  size: 20.h,
                ),
              ),
            ),
            onPressed: () {
              context.pop();
              // Handle back action
            },
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                AppAssets.moreHoriz,
                height: 25.h,
              ),
              onPressed: () {
                // Handle menu action
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Profile Header Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // Profile Picture and Info
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150'), // Replace with actual profile image URL
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${context.account.user!.firstName!} ${context.account.user!.lastName!}",
                      style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    5.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_pin, color: Colors.green),
                        Text(
                          "Ipswich",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                        10.horizontalSpace,
                        Text(
                          "100 Friends",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AppButton.primary(
                      text: "Edit Profile",
                      onPressed: () {
                        context.push(EditProfileScreen());
                      },
                      height: 45.h,
                      width: 137.w,
                    ),
                    10.verticalSpace,
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Tabs Section
              Container(
                color: Colors.grey[200],
                child: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  tabs: [
                    Tab(text: 'Posts'),
                    Tab(text: 'Comments'),
                    Tab(text: 'Media'),
                    Tab(text: 'More'),
                  ],
                ),
              ),
              // Expanded TabBarView to occupy remaining space
              Expanded(
                child: TabBarView(
                  children: [
                    // Posts Tab
                    Consumer<PostsProvider>(
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 16.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.h),
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
                                        if (post.imageUrlOne != null)
                                          post.imageUrlOne!,
                                        if (post.imageUrlTwo != null)
                                          post.imageUrlTwo!,
                                        if (post.imageUrlThree != null)
                                          post.imageUrlThree!,
                                        if (post.imageUrlFour != null)
                                          post.imageUrlFour!,
                                      ],
                                      videos: [
                                        if (post.videoUrlOne != null)
                                          post.videoUrlOne!,
                                        if (post.videoUrlTwo != null)
                                          post.videoUrlTwo!,
                                        if (post.videoUrlThree != null)
                                          post.videoUrlThree!,
                                        if (post.videoUrlFour != null)
                                          post.videoUrlFour!,
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
                    ),
                    // Comments Tab
                    Center(child: Text("Comments Tab Content")),
                    // Media Tab
                    Center(child: Text("Media Tab Content")),
                    // More Tab
                    Center(child: Text("More Tab Content")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
