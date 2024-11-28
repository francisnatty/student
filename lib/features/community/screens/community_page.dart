import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/core/utils/bottom_sheets.dart';
import 'package:student_centric_app/features/community/screens/community_tab.dart';
import 'package:student_centric_app/features/community/screens/explore_tab.dart';
import 'package:student_centric_app/widgets/app_button.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int selectedTabIndex = 0; // To track the selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Row(
          children: [
            Image.asset(
              AppAssets.logo,
              height: 39.h,
              width: 39.w,
            ),
          ],
        ),
        actions: [
          SvgPicture.asset(
            AppAssets.notifications,
          ),
          SizedBox(
            width: 10.w,
          ),
          GestureDetector(
            onTap: () {
              CustomBottomSheet.show(
                context: context,
                content: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(),
                      ],
                    ),
                    AppButton.primary(text: "Subscribe", onPressed: () {}),
                  ],
                ),
              );
            },
            child: CircleAvatar(),
          ),
          10.horizontalSpace,
        ],
      ),
      body: Column(
        children: [
          // Custom Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTabIndex = 0; // Community Tab Selected
                  });
                },
                child: Container(
                  width: 160.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: selectedTabIndex == 0
                        ? AppColors.primaryThree
                        : AppColors.primaryFour,
                    borderRadius: BorderRadius.circular(64.r),
                  ),
                  child: Center(
                    child: Text(
                      'Community',
                      style: TextStyle(
                        color:
                            selectedTabIndex == 0 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTabIndex = 1; // Explore Tab Selected
                  });
                },
                child: Container(
                  width: 160.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: selectedTabIndex == 1
                        ? AppColors.primaryThree
                        : AppColors.primaryFour,
                    borderRadius: BorderRadius.circular(64.r),
                  ),
                  child: Center(
                    child: Text(
                      'Explore',
                      style: TextStyle(
                        color:
                            selectedTabIndex == 1 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Tab Content
          Expanded(
            child: selectedTabIndex == 0 ? CommunityTab() : ExploreTab(),
          ),
        ],
      ),
    );
  }
}
