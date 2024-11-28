import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/core/extensions/account_extension.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/core/utils/bottom_sheets.dart';
import 'package:student_centric_app/core/utils/fcm.dart';
import 'package:student_centric_app/features/home/providers/post_provider.dart';
import 'package:student_centric_app/features/home/widgets/feed_posts_container.dart';
import 'package:student_centric_app/features/profile/screens/profile_screen.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the posts when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostsProvider>(context, listen: false).fetchHomeFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context);
    final posts = postsProvider.posts;
    final isLoading = postsProvider.isFetching;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Row(
          children: [
            Image.asset(
              AppAssets.logo,
              height: 35.h,
              width: 35.w,
            ),
          ],
        ),
        actions: [
          SvgPicture.asset(
            AppAssets.notifications,
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: () {
              CustomBottomSheet.show(
                context: context,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 24.r,
                          child: SvgPicture.asset(
                            AppAssets.profileIcon,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: CircleAvatar(
                            radius: 24.r,
                            child: Icon(
                              Icons.close,
                            ),
                          ),
                        )
                      ],
                    ),
                    10.verticalSpace,
                    Text(
                      "${context.account.user!.firstName!} ${context.account.user!.lastName!}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "100 Following  100 Followers",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.blackFour,
                      ),
                    ),
                    20.verticalSpace,
                    AppButton.primary(text: "Subscribe", onPressed: () {}),
                    20.verticalSpace,
                    ListTile(
                      onTap: () {
                        context.push(ProfileScreen());
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        AppAssets.profileIcon,
                        height: 25.h,
                      ),
                      title: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        AppAssets.profileUsersIcon,
                        height: 25.h,
                      ),
                      title: Text(
                        "Friends",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        AppAssets.taskSquare,
                        height: 25.h,
                      ),
                      title: Text(
                        "Activities",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        AppAssets.settings,
                        height: 25.h,
                      ),
                      title: Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        AppAssets.logOutIcon,
                        height: 25.h,
                      ),
                      title: Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    20.verticalSpace,
                  ],
                ).padHorizontal,
              );
            },
            child: CircleAvatar(
              child: SvgPicture.asset(
                AppAssets.profileIcon,
              ),
            ),
          ),
          10.horizontalSpace,
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : posts.isEmpty
              ? Center(
                  child: Text("No feeds available"),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: posts.map((post) {
                      return FeedPostsContainer(
                        userName:
                            "${post.user?.firstName} ${post.user?.lastName}" ??
                                "Default User",
                        timeAgo: "Just Now",
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
                      );
                    }).toList(),
                  ).padHorizontal,
                ),
    );
  }
}
