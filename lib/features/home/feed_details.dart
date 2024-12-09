import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/features/home/models/posts_model.dart';
import 'package:student_centric_app/features/home/providers/post_provider.dart';
import 'package:student_centric_app/features/home/widgets/feed_detail_container.dart';
import 'package:student_centric_app/features/home/widgets/response_widget.dart';

import '../../core/utils/app_assets.dart';
import '../../core/utils/app_colors.dart';
import '../../widgets/app_textfield.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../dashboard/screens/dashboard_screen.dart';

class FeedDetails extends StatelessWidget {
  const FeedDetails({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    var commentController = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.grey1,
      appBar: AppBar(
        backgroundColor: AppColors.grey1,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 87,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${post.title}',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600),
            ),
            4.verticalSpace,
            Text(
              '${post.subtitle}',
              style: TextStyle(
                  color: AppColors.blackThree,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Container(
            width: 55.w,
            height: 55.h,
            decoration: const BoxDecoration(
              color: AppColors.greyTwo,
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.back,
              size: 18.h,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          SvgPicture.asset(
            AppAssets.notifications,
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: SingleChildScrollView(child: Consumer<PostsProvider>(
          builder: (BuildContext context, PostsProvider viewModel, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FeedDetailContainer(
                  feedId: post.id,
                  userName: "${post.user?.firstName} ${post.user?.lastName}" ??
                      "Default User",
                  timeAgo: timeago.format(DateTime.parse(post.createdAt ?? '')),
                  postContent: post.content ?? "",
                  images: post.fileUploads
                          ?.where((e) => e.fileType == FileTypeEnums.image.name)
                          .map((e) => e.normalUrl ?? '')
                          .toList() ??
                      [],
                  videos: post.fileUploads
                          ?.where((e) => e.fileType == FileTypeEnums.video.name)
                          .map((e) => e.normalUrl ?? '')
                          .toList() ??
                      [],
                  pollTypeTitle: post.pollTypeTitle,
                  pollAnswers: post.pollAnswer?.split(","),
                  likeCount:
                      (post.likeOnFeeds != null && post.likeOnFeeds!.isNotEmpty)
                          ? post.likeOnFeeds!.first.feedLike.toString()
                          : '0',
                  voiceNoteUrl: null,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Responses',
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                10.verticalSpace,
                if (post.commentOnFeeds?.isEmpty ?? true)
                  Center(
                      child: SizedBox(
                    height: 140.h,
                    child: Text(
                      "No Comment",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )),
                ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: post.commentOnFeeds?.length ?? 0,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ResponseWidget(
                        fName: post.user?.firstName ?? '',
                        lName: post.user?.lastName ?? '',
                        time: post.createdAt ?? '',
                        post: post.commentOnFeeds![index],
                        feedLikes: (post.likeOnFeeds != null &&
                                post.likeOnFeeds!.isNotEmpty)
                            ? post.likeOnFeeds!.first.feedLike.toString()
                            : '0',
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AppTextfield.regular(
                    controller: commentController,
                    hintText:
                        'Response as ${post.user?.firstName} ${post.user?.lastName}',
                    prefixIcon: IconButton(
                      icon: SvgPicture.asset('assets/icons/profile.svg'),
                      onPressed: () {},
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        debugPrint('clicked');
                        if (commentController.text.isNotEmpty) {
                          await viewModel
                              .sendComment(
                                  feedId: post.id.toString() ?? '',
                                  comment: commentController.text.trim(),
                                  context: context)
                              .then((value) {
                            commentController.clear();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const DashboardScreen()));
                          });
                        }
                      },
                      child: (viewModel.sendCommentLoading)
                          ? const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : SvgPicture.asset(
                              AppAssets.attachmentIcon,
                              height: 10.h,
                              width: 10.w,
                              fit: BoxFit.scaleDown,
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
        )),
      ),
    );
  }
}
