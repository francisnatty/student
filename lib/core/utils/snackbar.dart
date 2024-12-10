import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

enum ToastType { success, error, normal }

class ToastUtil {
  static OverlayEntry? _currentToast;
  static bool _isVisible = false;

  static void show(
    BuildContext context, {
    required String message,
    IconData? icon = Icons.info,
    bool isLoading = false,
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    ToastType toastType = ToastType.normal,
  }) {
    // Safely remove existing toast
    if (_isVisible) {
      hide();
    }

    try {
      final overlayState = Overlay.of(context);
      _isVisible = true;

      OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          bottom: 50,
          width: MediaQuery.of(context).size.width,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: toastType == ToastType.success
                      ? Colors.green.withOpacity(0.2)
                      : toastType == ToastType.error
                          ? Colors.red.withOpacity(0.2)
                          : backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: toastType == ToastType.success
                          ? Colors.green.withOpacity(0.2)
                          : toastType == ToastType.error
                              ? Colors.red.withOpacity(0.2)
                              : Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLoading) ...[
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(textColor),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      )
                    ] else if (icon != null) ...[
                      Icon(icon,
                          color: toastType == ToastType.success
                              ? Colors.black
                              : toastType == ToastType.error
                                  ? Colors.red
                                  : textColor,
                          size: 20),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                    Flexible(
                      child: Text(
                        message,
                        style: TextStyle(
                          color: toastType == ToastType.success
                              ? Colors.black
                              : toastType == ToastType.error
                                  ? Colors.red
                                  : textColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      _currentToast = overlayEntry;
      overlayState.insert(overlayEntry);

      if (!isLoading) {
        Future.delayed(duration, () {
          hide();
        });
      }
    } catch (e) {
      debugPrint('Error showing toast: $e');
    }
  }

  static void hide() {
    if (_isVisible && _currentToast != null) {
      try {
        _currentToast?.remove();
      } catch (e) {
        debugPrint('Error removing toast: $e');
      }
      _currentToast = null;
      _isVisible = false;
    }
  }
}
