


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart'; // Ensure Provider is imported
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/auth/providers/auth_provider.dart'; // Import AuthProvider


class ChatOption extends StatefulWidget {
  const ChatOption({super.key});

  @override
  State<ChatOption> createState() => _ChatOptionState();
}

class _ChatOptionState extends State<ChatOption> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final authProvider =
    Provider.of<AuthProvider>(context); // Access AuthProvider

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.verticalSpace,
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(
                   'Chat Options',
                   style: TextStyle(
                     fontSize: 20.sp,
                     fontWeight: FontWeight.w600,
                   ),
                 ),
                 GestureDetector(
                     onTap: (){
                       Navigator.of(context).pop();
                     },
                     child: SvgPicture.asset('assets/icons/close.svg'))
               ],
             ),
              40.verticalSpace,
              Text(
                'Clear Chat',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.blackThree,
                ),
              ),
              5.verticalSpace,
              const Divider(thickness: 0.3,),
              10.verticalSpace,
              Text(
                'Archive Chat',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.blackThree,
                ),
              ),
              5.verticalSpace,
              const Divider(thickness: 0.3,),
              10.verticalSpace,
              Text(
                'Block Chat',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.blackThree,
                ),
              ),
              5.verticalSpace,
              const Divider(thickness: 0.3,),
              10.verticalSpace,
              Text(
                'Report',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.blackThree,
                ),
              ),
              30.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
