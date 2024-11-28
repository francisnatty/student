import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';

class PasswordCriteria extends StatelessWidget {
  final bool isMet;
  final String label;

  const PasswordCriteria({
    Key? key,
    required this.isMet,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 5.r,
          backgroundColor: isMet ? AppColors.primaryColor : AppColors.blackFour,
        ),
        5.horizontalSpace,
        Text(
          label,
          style: TextStyle(
            color: isMet ? AppColors.primaryColor : AppColors.blackFour,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}

final passwordNotifier = ValueNotifier<bool>(false);

class PasswordValidation {
  bool hasMinLength(String password) => password.length >= 8;
  bool hasUpperLowerCase(String password) =>
      password.contains(RegExp(r'[A-Z]')) &&
      password.contains(RegExp(r'[a-z]'));
  bool hasNumber(String password) => password.contains(RegExp(r'\d'));
  bool hasSpecialCharacter(String password) =>
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  bool isPasswordValid(String password) {
    return hasMinLength(password) &&
        hasUpperLowerCase(password) &&
        hasNumber(password) &&
        hasSpecialCharacter(password);
  }
}
