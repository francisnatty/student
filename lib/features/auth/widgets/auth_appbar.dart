import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';

class AuthAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool centerTitle;
  final VoidCallback? onPressed;
  final PreferredSizeWidget? bottom; // Added bottom property

  const AuthAppbar({
    super.key,
    this.title,
    this.actions,
    this.centerTitle = false,
    this.onPressed,
    this.bottom, // Initialize bottom
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight +
      (bottom?.preferredSize.height ?? 0.0)); // Adjusted preferredSize

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: EdgeInsets.only(left: 15.w),
        child: GestureDetector(
          onTap: () {
            if (onPressed != null) {
              onPressed!();
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Container(
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
      ),
      centerTitle: centerTitle,
      actions: actions,
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
      bottom: bottom, // Set bottom property here
    );
  }
}
