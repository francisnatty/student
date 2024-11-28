import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/home/home_screen.dart';
import 'package:student_centric_app/widgets/app_textfield.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Explore",
          style: TextStyle(
            fontSize: 16.sp,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(),
          ),
        ],
      ),
      body: Column(
        children: [
          AppTextfield.regular(
            hintText: "Search",
            prefixIcon: IconButton(
              icon: SvgPicture.asset(
                AppAssets.inactiveSearchIcon,
                height: 25.h,
              ),
              onPressed: () {},
            ),
          ),
          20.verticalSpace,
          Row(
            children: [
              Container(
                height: 30.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryFive,
                  borderRadius: BorderRadius.circular(
                    20.r,
                  ),
                ),
                child: Center(
                  child: Text(
                    "For you",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              Container(
                height: 30.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.grey1,
                  borderRadius: BorderRadius.circular(
                    20.r,
                  ),
                ),
                child: Center(
                  child: Text(
                    "For you",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.blackFour,
                    ),
                  ),
                ),
              )
            ],
          ),
          20.verticalSpace,
          SearchScreenTile(
            trendingWhere: "Trending in your school",
            trendingContents: "2025/2026 Admission",
            numberOfPosts: "78.7K posts",
          ),
          10.verticalSpace,
          SearchScreenTile(
            trendingWhere: "Trending in your school",
            trendingContents: "2025/2026 Admission",
            numberOfPosts: "78.7K posts",
          ),
          10.verticalSpace,
          SearchScreenTile(
            trendingWhere: "Trending in your school",
            trendingContents: "2025/2026 Admission",
            numberOfPosts: "78.7K posts",
          ),
          10.verticalSpace,
          SearchScreenTile(
            trendingWhere: "Trending in your school",
            trendingContents: "2025/2026 Admission",
            numberOfPosts: "78.7K posts",
          )
        ],
      ).padHorizontal,
    );
  }
}

class SearchScreenTile extends StatelessWidget {
  final String trendingWhere;
  final String trendingContents;
  final String numberOfPosts;
  const SearchScreenTile(
      {super.key,
      required this.trendingWhere,
      required this.trendingContents,
      required this.numberOfPosts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          trendingWhere,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.blackFour,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              trendingContents,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SvgPicture.asset(
              AppAssets.moreHoriz,
              height: 24.h,
            ),
          ],
        ),
        Text(
          numberOfPosts,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.blackFour,
          ),
        ),
      ],
    );
  }
}
