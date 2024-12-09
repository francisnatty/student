import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FloatingBanner extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onDismiss;

  const FloatingBanner({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDismiss,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BannerManager {
  final BuildContext context;

  OverlayEntry? _currentBanner;

  BannerManager(this.context);

  void showBanner({
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    // If there's an existing banner, remove it
    _currentBanner?.remove();

    _currentBanner = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0, // Adjust the position as needed
        left: 16.0,
        right: 16.0,
        child: FloatingBanner(
          message: message,
          backgroundColor: backgroundColor,
          icon: icon,
          onDismiss: hideBanner,
        ),
      ),
    );

    // Insert the banner into the Overlay
    Overlay.of(context).insert(_currentBanner!);

    // Auto dismiss after the specified duration
    Future.delayed(duration, () {
      hideBanner();
    });
  }

  void hideBanner() {
    _currentBanner?.remove();
    _currentBanner = null;
  }
}
