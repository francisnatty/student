import 'dart:async';

import 'package:flutter/material.dart';
import 'package:student_centric_app/main.dart';

Timer? _bannerTimer;

void showAutoDismissBanner({
  required String message,
  required Color backgroundColor,
  Duration duration = const Duration(seconds: 3),
}) {
  // Hide any existing banner
  scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();

  // Cancel any existing timer
  _bannerTimer?.cancel();

  // Show the new banner
  scaffoldMessengerKey.currentState?.showMaterialBanner(
    MaterialBanner(
      elevation: 10,
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      actions: [
        TextButton(
          onPressed: () {
            scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();
            _bannerTimer?.cancel();
          },
          child: const Text(
            "DISMISS",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );

  // Schedule the banner to hide after the specified duration
  _bannerTimer = Timer(duration, () {
    scaffoldMessengerKey.currentState?.hideCurrentMaterialBanner();
  });
}
