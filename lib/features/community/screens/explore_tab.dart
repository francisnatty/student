import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';

class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List of cards
            _buildCard(
              title: 'Founders in London',
              description:
                  'For students building a business in London and Europe',
              membersCount: '12k+',
              memberImages: [
                'assets/images/user1.png',
                'assets/images/user2.png',
                'assets/images/user3.png',
              ],
            ),
            SizedBox(height: 16.h),
            _buildCard(
              title: 'Oxford Alumni',
              description:
                  'For students building a business in London and Europe',
              membersCount: '12k+',
              memberImages: [
                'assets/images/user1.png',
                'assets/images/user2.png',
                'assets/images/user3.png',
              ],
            ),
            SizedBox(height: 16.h),
            _buildCard(
              title: 'Wine Tasting',
              description:
                  'For students building a business in London and Europe',
              membersCount: '12k+',
              memberImages: [
                'assets/images/user1.png',
                'assets/images/user2.png',
                'assets/images/user3.png',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String description,
    required String membersCount,
    required List<String> memberImages,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10.r,
            spreadRadius: 1.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              SvgPicture.asset(
                AppAssets.coloredPeopleIcon,
                width: 24.r,
                height: 24.r,
                fit: BoxFit.cover,
              ),
              7.horizontalSpace,
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 16.h),

          // Member Avatars and Count
          Row(
            children: [
              // Display member avatars
              ...memberImages.map((imagePath) {
                return Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: CircleAvatar(
                    radius: 20.r,
                    child: ClipOval(
                      child: SvgPicture.asset(
                        AppAssets.profileIcon,
                        width: 27.r,
                        height: 27.r,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }).toList(),
              Spacer(),
              // Members count
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  membersCount,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
