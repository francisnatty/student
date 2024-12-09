// phone_number_otp_verification.dart

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart'; // Ensure Provider is imported
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/auth/providers/auth_provider.dart'; // Import AuthProvider
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/selector_loader.dart';

const int resendIn = 60;

class PhoneNumberOtpVerification extends StatefulWidget {
  const PhoneNumberOtpVerification({super.key});

  @override
  State<PhoneNumberOtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<PhoneNumberOtpVerification> {
  late Timer _resendTimer;
  late final TextEditingController controller;
  late FocusNode focusNode;

  int _secondsRemaining = resendIn;

  bool isActive = false;
  String otp = '';
  bool isSendingOtp = false;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
    focusNode = FocusNode();
    startResendTimer();

    controller.addListener(() {
      isActive = controller.text.isNotEmpty;
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
    final authProvider =
        Provider.of<AuthProvider>(context); // Access AuthProvider

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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.verticalSpace,
              Text(
                'Verify Phone Number',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              10.verticalSpace,
              Text(
                'Kindly enter the 6-Digit OTP sent to your Phone Number: ${authProvider.phoneNumber} to continue registration',
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
                  color: isOtpFieldActive
                      ? AppColors.primaryColor
                      : Colors.black, // Change text color based on active state
                ),
              ),
              13.verticalSpace,
              Pinput(
                length: 6,
                controller: controller,
                focusNode: focusNode, // Add focus node
                defaultPinTheme: PinTheme(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: isOtpFieldActive
                          ? AppColors.primaryColor
                          : Colors.black, // Blue border when active
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
                    color: isOtpFieldActive
                        ? AppColors.primaryColor
                        : Colors.black, // Change text color to blue when active
                  ),
                ),
                onCompleted: (value) {
                  otp = value;
                },
              ),
              20.verticalSpace,
              Container(
                width: _secondsRemaining > 0 ? 180.w : 137.w,
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
                      ? const SelectorLoader()
                      : Text.rich(
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                          TextSpan(
                            children: [
                              if (_secondsRemaining > 0) ...{
                                const TextSpan(
                                  text: 'Resend Code in ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              },
                              if (_secondsRemaining <= 0) ...{
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

                                      // Call provider to resend OTP
                                      await authProvider.sendPhoneOtp(
                                        email: authProvider.email,
                                        phoneNumber: authProvider.phoneNumber,
                                      );

                                      setState(() {
                                        isSendingOtp = false;
                                        _secondsRemaining = resendIn;
                                      });
                                      startResendTimer();
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
              authProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppButton.primary(
                      text: "Verify OTP",
                      onPressed: () async {
                        if (otp.isEmpty || otp.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Please enter a valid 6-digit OTP."),
                            ),
                          );
                          return;
                        }

                        // Call provider to verify OTP
                        await authProvider.verifyPhoneOtp(
                          otp: otp,
                          context: context,
                        );
                      },
                    ),
              30.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
