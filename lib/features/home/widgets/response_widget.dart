import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/utils/app_assets.dart';
import '../models/posts_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class ResponseWidget extends StatelessWidget {
  const ResponseWidget(
      {super.key,
      required this.post,
      required this.fName,
      required this.lName,
      required this.time,
      required this.feedLikes});
  final CommentOnFeeds post;
  final String fName;
  final String lName;
  final String time;
  final String feedLikes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
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
                      "$fName $lName" ?? "",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      timeago.format(DateTime.parse(time ?? '')),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Post Content
          Text(
            post.comment ?? "",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    AppAssets.likeIcon,
                    height: 20.h,
                    width: 20.w,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    (post.likeOnFeeds !=null && post.likeOnFeeds!.isNotEmpty )
                        ? "${post.likeOnFeeds?.first.commentLike ?? 0}"
                        : '0',
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
                    feedLikes ?? '0',
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
