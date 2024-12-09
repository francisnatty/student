import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/auth/providers/auth_provider.dart';
import 'package:student_centric_app/features/auth/widgets/auth_appbar.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';
import 'package:student_centric_app/widgets/selector_loader.dart';

const int resendIn = 60;

class ForgortPasswordOtpScreen extends StatefulWidget {
  const ForgortPasswordOtpScreen({super.key});

  @override
  State<ForgortPasswordOtpScreen> createState() =>
      _ForgortPasswordOtpScreenState();
}

class _ForgortPasswordOtpScreenState extends State<ForgortPasswordOtpScreen> {
  late Timer _resendTimer;
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  int _secondsRemaining = resendIn;

  bool isActive = false;
  String otp = '';
  bool isSendingOtp = false;

  @override
  void initState() {
    super.initState();
    startResendTimer();

    controller.addListener(() {
      setState(() {
        isActive = controller.text.isNotEmpty;
      });
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
    final authProvider = Provider.of<AuthProvider>(context);
    bool isOtpFieldActive = focusNode.hasFocus;

    return Scaffold(
      appBar: const AuthAppbar(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          30.verticalSpace,
          Text(
            'Verify OTP\nEmail Address',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          30.verticalSpace,
          Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return Text(
                'Kindly enter the 6-Digit OTP sent to your Email Address: ${provider.email} to revocer your password',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
              );
            },
          ),
          20.verticalSpace,
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
                      : Colors.grey, // Adjust colors as needed
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
                color: isOtpFieldActive ? AppColors.primaryColor : Colors.black,
              ),
            ),
            onCompleted: (value) {
              otp = value;
            },
          ),
          20.verticalSpace,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: 10.h,
              horizontal: 16.w,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(64.r),
            ),
            child: Center(
              child: authProvider.isLoading || isSendingOtp
                  ? const SelectorLoader()
                  : _secondsRemaining > 0
                      ? Text(
                          'Resend Code in ${_secondsRemaining}s',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            setState(() {
                              isSendingOtp = true;
                            });

                            await authProvider.requestEmailOtp();

                            setState(() {
                              isSendingOtp = false;
                              _secondsRemaining = resendIn;
                            });
                            startResendTimer();
                          },
                          child: Text(
                            'Resend Code',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
            ),
          ),
          20.verticalSpace,
          AppButton.primary(
            text: "Verify OTP",
            isActive: otp.length == 6 && !authProvider.isLoading,
            isLoading: authProvider.isLoading,
            onPressed: otp.length == 6 && !authProvider.isLoading
                ? () {
                    authProvider.verifyEmailOtpForForgortPassword(
                      otp: otp,
                      context: context,
                    );
                  }
                : null,
          ),
          30.verticalSpace,
        ],
      ).padHorizontal,
    );
  }
}
