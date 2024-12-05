import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/features/auth/screens/login_screen.dart';
import 'package:student_centric_app/features/auth/screens/sign_up_screen.dart';
import 'package:student_centric_app/main.dart';
import 'package:student_centric_app/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  late Timer _timer;

  // List of onboarding images
  final List<String> _onboardingImages = [
    AppAssets.onboardingImageOne,
    AppAssets.onboardingImageTwo,
    AppAssets.onboardingImageThree,
    AppAssets.onboardingImageFour,
  ];

  // Auto-scroll interval in seconds
  final int _autoScrollInterval = 4;

  @override
  void initState() {
    super.initState();
    // Initialize the timer for auto-scrolling
    _timer =
        Timer.periodic(Duration(seconds: _autoScrollInterval), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        if (nextPage >= _onboardingImages.length) {
          nextPage = 0; // Loop back to the first page
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer
    _pageController.dispose(); // Dispose the PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // PageView for onboarding images
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: size.height * 0.65, // Extend the image slightly below
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(_onboardingImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Content Section with rounded top border, taking up remaining space
          Positioned(
            top: size.height *
                0.53, // Start the white container slightly above the image bottom
            left: 0,
            right: 0,
            bottom: 0, // Anchor to the bottom of the screen
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    24.r,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Smooth Page Indicator
                  SmoothPageIndicator(
                    controller: _pageController, // PageController
                    count: _onboardingImages.length, // Total number of pages
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.blue[100]!,
                      activeDotColor: AppColors.primaryColor,
                      dotHeight: 8.h,
                      dotWidth: 20.w,
                    ),
                  ),
                  20.verticalSpace,

                  // Title Text
                  Text(
                    'Network with\nyour clique',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  32.verticalSpace,
                  // Get Started Button
                  AppButton.primary(
                    text: 'Get Started',
                    onPressed: () {
                      context.push(const SignUpScreen());
                    },
                  ),
                  const SizedBox(height: 16),

                  // Login Button
                  AppButton.secondary(
                    text: 'Login',
                    onPressed: () {
                      // Handle Login
                      context.push(LoginScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
