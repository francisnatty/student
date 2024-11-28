import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:student_centric_app/features/auth/providers/auth_provider.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/auth/screens/enter_phone_number.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';
import 'package:student_centric_app/widgets/selector_loader.dart';

const int resendIn = 60;

class EmailOtpVerification extends StatefulWidget {
  const EmailOtpVerification({super.key});

  @override
  State<EmailOtpVerification> createState() => _EmailOtpVerificationState();
}

class _EmailOtpVerificationState extends State<EmailOtpVerification> {
  late Timer _resendTimer;
  late final TextEditingController controller;
  late FocusNode focusNode;

  int _secondsRemaining = resendIn;

  bool isActive = false;
  bool isSendingOtp = false;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
    focusNode = FocusNode();
    startResendTimer();

    controller.addListener(() {
      isActive = controller.text.length == 6;
      setState(() {});
    });

    focusNode.addListener(() {
      setState(() {});
    });
  }

  void startResendTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _resendTimer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _resendTimer.cancel();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool isOtpFieldActive = focusNode.hasFocus;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            30.verticalSpace,
            Text(
              'Verify Email',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            10.verticalSpace,
            Text(
              'Kindly enter a 6-Digit OTP sent to your Email Address: ${authProvider.email} to continue registration',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.blackThree,
              ),
            ),
            20.verticalSpace,
            Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 16.sp,
                color: isOtpFieldActive ? AppColors.primaryColor : Colors.black,
              ),
            ),
            13.verticalSpace,
            Pinput(
              length: 6,
              controller: controller,
              focusNode: focusNode,
              defaultPinTheme: PinTheme(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: isOtpFieldActive
                        ? AppColors.primaryColor
                        : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    if (isOtpFieldActive)
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                  ],
                ),
                height: 50.h,
                width: 50.w,
                textStyle: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color:
                      isOtpFieldActive ? AppColors.primaryColor : Colors.black,
                ),
              ),
            ),
            20.verticalSpace,
            Container(
              width: _secondsRemaining > 1 ? 180.w : 137.w,
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 16.w,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryFour,
                borderRadius: BorderRadius.circular(64.r),
              ),
              child: Center(
                child: isSendingOtp
                    ? SelectorLoader()
                    : Text.rich(
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                        TextSpan(
                          children: [
                            if (_secondsRemaining > 1) ...{
                              TextSpan(
                                text: 'Resend Code in ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            },
                            if (_secondsRemaining < 1) ...{
                              TextSpan(
                                text: 'Resend Code',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    setState(() {
                                      isSendingOtp = true;
                                    });

                                    try {
                                      await authProvider.requestEmailOtp(
                                        email: authProvider.email,
                                        showBanner: true,
                                      );
                                      _secondsRemaining = resendIn;
                                      startResendTimer();
                                    } catch (e) {
                                      // Handle error if necessary
                                    }

                                    setState(() {
                                      isSendingOtp = false;
                                    });
                                  },
                              ),
                            },
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
            20.verticalSpace,
            Text(
              "Having issues verifying?",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.blackThree,
              ),
            ),
            20.verticalSpace,
            AppButton.primary(
              text: "Verify OTP",
              isActive: isActive && !isLoading,
              isLoading: isLoading,
              onPressed: isActive && !isLoading
                  ? () async {
                      try {
                        await authProvider.verifyEmailOtp(
                          otp: controller.text.trim(),
                          context: context,
                        );
                      } catch (e) {}
                    }
                  : null,
            ),
            30.verticalSpace,
          ],
        ).padHorizontal,
      ),
    );
  }
}
