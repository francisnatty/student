import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double fontSize;
  final double height;
  final double width;
  final bool isActive;
  final bool isLoading;

  // Primary Button Constructor
  AppButton.primary({
    super.key,
    required this.text,
    required this.onPressed,
    this.isActive = true,
    this.isLoading = false,
    this.backgroundColor = AppColors.primaryColor,
    this.textColor = Colors.white,
    double? fontSize, // No need to use 16.sp here directly
    double? height, // Remove 64.h here
    double? width, // Use double.infinity without .sp or .h
  })  : fontSize = fontSize ?? 16.sp,
        height = height ?? 64.h,
        width = width ?? double.infinity,
        borderColor = Colors.transparent;

  // Secondary Button Constructor
  AppButton.secondary({
    super.key,
    required this.text,
    required this.onPressed,
    this.isActive = true,
    this.isLoading = false,
    this.backgroundColor = Colors.white,
    this.textColor = AppColors.primaryColor,
    this.borderColor = AppColors.primaryColor,
    double? fontSize,
    double? height,
    double? width,
  })  : fontSize = fontSize ?? 16.sp,
        height = height ?? 64.h,
        width = width ?? double.infinity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: isActive && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? backgroundColor : const Color(0xffcfdafe),
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(64.r),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
