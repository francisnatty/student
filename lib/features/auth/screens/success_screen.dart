import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';

class SuccessScreen extends StatelessWidget {
  final String mainText;
  final String buttonText;
  final VoidCallback? onPressed;

  const SuccessScreen({
    super.key,
    this.mainText = "Profile Created \nSuccessfully",
    this.buttonText = "Proceed to Dashboard",
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Define the height of the successImage
    final double successImageHeight = 200.h;
    final double successImageWidth = 200.w;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Image.asset(
              AppAssets.successBackground,
              width: screenWidth,
              height: screenHeight * 0.45, // 45% of screen height
              fit: BoxFit.cover,
            ),
          ),
          // Positioned successImage at the boundary between background and main background
          Positioned(
            top: (screenHeight * 0.45) - (successImageHeight / 2),
            left: (screenWidth - successImageWidth) / 2,
            child: Image.asset(
              AppAssets.successImage,
              width: successImageWidth,
              height: successImageHeight,
              fit: BoxFit.contain,
            ),
          ),
          // Content at the bottom of the screen
          Positioned(
            bottom: 50.h, // 50 logical pixels from the bottom
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mainText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                70.verticalSpace,
                AppButton.primary(
                  text: buttonText,
                  onPressed: onPressed ??
                      () {
                        context.push(const DashboardScreen());
                      },
                ),
              ],
            ).padHorizontal, // Apply horizontal padding
          ),
        ],
      ),
    );
  }
}
