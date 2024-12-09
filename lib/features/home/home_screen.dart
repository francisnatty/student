import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/core/extensions/account_extension.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/core/utils/bottom_sheets.dart';
import 'package:student_centric_app/features/home/bloc/home_bloc.dart';
import 'package:student_centric_app/features/home/feed_details.dart';
import 'package:student_centric_app/features/home/providers/post_provider.dart';
import 'package:student_centric_app/features/home/widgets/feed_posts_container.dart';
import 'package:student_centric_app/features/profile/screens/profile_screen.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the posts when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<PostsProvider>(context, listen: false).fetchHomeFeed();
      context.read<HomeBloc>().add(GetFeeds());
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
                            child: const Icon(
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
                        context.push(const ProfileScreen());
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
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state.status == HomeStatus.error && state.posts == null) {
                  return Text(state.error!.message);
                } else if (state.status == HomeStatus.loading &&
                    state.posts == null) {
                  return Skeletonizer(
                      enabled: true,
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return const FeedPostsContainer(
                            images: [
                              'https://images.pexels.com/photos/301926/pexels-photo-301926.jpeg?auto=compress&cs=tinysrgb&w=800',
                              'https://images.pexels.com/photos/301926/pexels-photo-301926.jpeg?auto=compress&cs=tinysrgb&w=800',
                              'https://images.pexels.com/photos/301926/pexels-photo-301926.jpeg?auto=compress&cs=tinysrgb&w=800'
                            ],
                            videos: [
                              'https://images.pexels.com/photos/301926/pexels-photo-301926.jpeg?auto=compress&cs=tinysrgb&w=800',
                              'https://images.pexels.com/photos/301926/pexels-photo-301926.jpeg?auto=compress&cs=tinysrgb&w=800',
                              'https://images.pexels.com/photos/301926/pexels-photo-301926.jpeg?auto=compress&cs=tinysrgb&w=800'
                            ],
                            userName: 'Mock data',
                            timeAgo: 'Mock Time',
                            postContent: 'Mock Content',
                          );
                        },
                      ));
                } else if (state.posts != null) {
                  final posts = state.posts!.data;
                  return ListView.separated(
                      itemCount: posts!.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 15.h,
                        );
                      },
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FeedDetails(
                                  post: post,
                                ),
                              ),
                            );
                          },
                          child: FeedPostsContainer(
                            userName:
                                "${post.user?.firstName} ${post.user?.lastName}" ??
                                    "Default User",
                            timeAgo: timeago
                                .format(DateTime.parse(post.createdAt ?? '')),
                            postContent: post.content ?? "",
                            images: post.fileUploads
                                    ?.where((e) =>
                                        e.fileType == FileTypeEnums.image.name)
                                    .map((e) => e.normalUrl ?? '')
                                    .toList() ??
                                [],
                            videos: post.fileUploads
                                    ?.where((e) =>
                                        e.fileType == FileTypeEnums.video.name)
                                    .map((e) => e.normalUrl ?? '')
                                    .toList() ??
                                [],
                            pollTypeTitle: post.pollTypeTitle,
                            pollAnswers: post.pollAnswer?.split(","),
                            voiceNoteUrl: null,
                          ),
                        ).padHorizontal;
                      });
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
