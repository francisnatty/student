import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomSheet {
  static Future<void> show({
    required BuildContext context,
    required Widget content,
    bool dismissible = true,
  }) {
    return showModalBottomSheet(
      context: context,
      isDismissible: dismissible,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        // Use MediaQuery to get the current view insets (e.g., keyboard height)
        final viewInsets = MediaQuery.of(context).viewInsets;

        return Padding(
          padding: EdgeInsets.only(bottom: viewInsets.bottom),
          child: Container(
            // Remove the fixed height to allow dynamic resizing
            // height: height ?? 430.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: SingleChildScrollView(
              // Ensure the bottom sheet content scrolls if needed
              child: content,
            ),
          ),
        );
      },
    );
  }
}
