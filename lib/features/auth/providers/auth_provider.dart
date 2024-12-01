// auth_provider.dart

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/core/network/api_service.dart';
import 'package:student_centric_app/core/utils/bottom_sheets.dart';
import 'package:student_centric_app/core/utils/fcm.dart';
import 'package:student_centric_app/features/auth/models/user_model.dart';
import 'package:student_centric_app/features/auth/screens/basic_information_screen.dart';
import 'package:student_centric_app/features/auth/screens/change_password_screen.dart';
import 'package:student_centric_app/features/auth/screens/enter_phone_number.dart';
import 'package:student_centric_app/features/auth/screens/forgort_password_otp_screen.dart';
import 'package:student_centric_app/features/auth/screens/login_screen.dart';
import 'package:student_centric_app/features/auth/screens/success_screen.dart';
import 'package:student_centric_app/features/auth/widgets/email_verification.dart';
import 'package:student_centric_app/features/auth/widgets/otp_verification.dart';
import 'package:student_centric_app/features/dashboard/screens/dashboard_screen.dart';

class AuthProvider extends ChangeNotifier {
  // Variables to hold authentication state
  bool _isLoading = false;
  String? _email;
  String? _phoneNumber;

  // Getters
  bool get isLoading => _isLoading;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;

  // Method to sign up a user
  Future<void> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
    bool showBanner = true,
  }) async {
    _isLoading = true;
    notifyListeners();

    final data = {
      "email": email,
      "password": password,
      "confirm_password": confirmPassword,
    };

    final response = await ApiService.instance.post(
      "/auth/onboarding/register",
      data: data,
      isProtected: false,
      showBanner: showBanner,
    );

    _isLoading = false;
    if (response != null && response.statusCode == 200) {
      _email = email;
      CustomBottomSheet.show(
        context: context,
        content: const EmailOtpVerification(),
      );
      notifyListeners();
      // Additional logic if needed
    } else {
      // Handle error if necessary
      notifyListeners();
    }
  }

  // Method to request Email OTP
  Future<void> requestEmailOtp({
    String? email,
    bool showBanner = true,
  }) async {
    _isLoading = true;
    notifyListeners();

    final requestData = {
      "email": email ?? _email,
    };

    final response = await ApiService.instance.post(
      "/auth/onboarding/email/resend",
      data: requestData,
      isProtected: false,
      showBanner: showBanner,
    );

    _isLoading = false;
    if (response != null && response.statusCode == 200) {
      notifyListeners();
      // Additional logic if needed
    } else {
      // Handle error if necessary
      notifyListeners();
    }
  }

  // Method to verify Email OTP
  Future<void> verifyEmailOtp({
    required String otp,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    final data = {
      "email": _email,
      "otp": int.parse(otp),
    };

    try {
      final response = await ApiService.instance.post(
        "/auth/onboarding/verify/emailotp",
        data: data,
        isProtected: false,
        showBanner: true,
      );

      if (response != null && response.statusCode == 200) {
        context.push(const EnterPhoneNumberScreen());
        notifyListeners();
        // Navigate to phone number entry screen
      } else if (response != null && response.statusCode == 400) {
        // Example: Invalid OTP
        // Show error message
      } else {
        // Handle other errors if necessary
      }
    } catch (e) {
      // Handle exception
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // **New Methods for Phone Number and OTP**

  /// Method to add phone number
  Future<void> addPhoneNumber({
    required String email,
    required String phoneNumber,
    required BuildContext context,
    bool showBanner = true,
  }) async {
    _isLoading = true;
    notifyListeners();

    final data = {
      "email": email,
      "phone_number": phoneNumber,
    };

    try {
      final response = await ApiService.instance.patch(
        "/auth/onboarding/phoneNumber/stageTwo",
        data: data,
        showBanner: showBanner,
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        _phoneNumber = phoneNumber;
        // Automatically send OTP after adding phone number
        await sendPhoneOtp(
          email: email,
          phoneNumber: phoneNumber,
          showBanner: showBanner,
        );
        // Show OTP verification bottom sheet
        CustomBottomSheet.show(
          context: context,
          content: PhoneNumberOtpVerification(),
        );
        notifyListeners();
      } else {
        // Handle error if necessary
        notifyListeners();
      }
    } catch (e) {
      // Handle exception
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Method to send/resend phone number OTP
  Future<void> sendPhoneOtp({
    String? email,
    String? phoneNumber,
    bool showBanner = true,
  }) async {
    _isLoading = true;
    notifyListeners();

    final data = {
      "email": email ?? _email,
      "phone_number": phoneNumber ?? _phoneNumber,
    };

    try {
      final response = await ApiService.instance.post(
        "/auth/onboarding/phoneNumber/resend/otp",
        data: data,
        showBanner: showBanner,
      );

      if (response != null && response.statusCode == 200) {
        // OTP sent successfully
        notifyListeners();
      } else {
        // Handle error if necessary
        notifyListeners();
      }
    } catch (e) {
      // Handle exception
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Method to verify phone number OTP
  Future<void> verifyPhoneOtp({
    required String otp,
    required BuildContext context,
    bool showBanner = true,
  }) async {
    _isLoading = true;
    notifyListeners();

    final data = {
      "phone_number": _phoneNumber,
      "otp": int.parse(otp),
    };

    try {
      final response = await ApiService.instance.post(
        "/auth/onboarding/verify/otp",
        data: data,
        showBanner: showBanner,
      );

      if (response != null && response.statusCode == 200) {
        // OTP verified successfully
        // Navigate to the next screen, e.g., Basic Information
        context.push(BasicInformationScreen());
        notifyListeners();
      } else if (response != null && response.statusCode == 400) {
        // Example: Invalid OTP
        // Show error message
      } else {
        // Handle other errors if necessary
      }
    } catch (e) {
      // Handle exception
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  UserModel? _user;
  String? _accessToken;
  bool _isLoggingIn = false;

  UserModel? get user => _user;
  String? get accessToken => _accessToken;
  bool get isLoggingIn => _isLoggingIn;

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
    bool showBanner = true,
  }) async {
    _isLoggingIn = true;
    notifyListeners();

    String? token = await FCM.getDeviceFCMToken();
    print("FCM Token: $token");

    final data = {
      "email": email,
      "password": password,
      "firebaseToken": token,
    };

    try {
      final response = await ApiService.instance.post(
        "/auth/onboarding/login",
        data: data,
        showBanner: showBanner,
      );

      if (response != null && response.statusCode == 200) {
        final responseData = response.data;

        // Parse user data
        _user = UserModel.fromJson(responseData['data']);

        // Store access token securely
        _accessToken = responseData['access_token'];
        print(_accessToken);
        context.pushAndRemoveUntil(
          DashboardScreen(),
          (p0) => false,
        );

        const FlutterSecureStorage _storage = FlutterSecureStorage();

        await _storage.write(key: 'access_token', value: _accessToken);
        print("LOGIN SUCCESSFUL");

        notifyListeners();
      } else {}
    } catch (e) {
      // Handle exception, possibly network error
      // Show error using a snackbar or dialog
    } finally {
      _isLoggingIn = false;
      notifyListeners();
    }
  }

  // Method to initiate forgot password
  Future<void> forgotPassword({
    required String email,
    required BuildContext context,
    bool showBanner = true,
  }) async {
    _isLoading = true;
    notifyListeners();

    final data = {"email": email};

    final response = await ApiService.instance.post(
      "/auth/forgot-password",
      data: data,
      isProtected: false,
      showBanner: showBanner,
    );

    _isLoading = false;
    if (response != null && response.statusCode == 200) {
      _email = email;
      context.push(ForgortPasswordOtpScreen());
      notifyListeners();
    } else {
      // Handle error (e.g., show a snackbar or dialog)
      notifyListeners();
    }
  }

  // Method to verify Email OTP
  Future<void> verifyEmailOtpForForgortPassword({
    required String otp,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    final data = {
      "email": _email,
      "otp": int.parse(otp),
    };

    try {
      final response = await ApiService.instance.post(
        "/auth/onboarding/verify/emailotp",
        data: data,
        isProtected: false,
        showBanner: true,
      );

      if (response != null && response.statusCode == 200) {
        context.push(const ChangePasswordScreen());
        notifyListeners();
        // Navigate to phone number entry screen
      } else if (response != null && response.statusCode == 400) {
        // Example: Invalid OTP
        // Show error message
      } else {
        // Handle other errors if necessary
      }
    } catch (e) {
      // Handle exception
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to reset password
  Future<void> resetPassword({
    required String newPassword,
    required String confirmNewPassword,
    required BuildContext context,
    bool showBanner = true,
  }) async {
    _isLoading = true;
    notifyListeners();

    final data = {
      "email": _email,
      "new_password": newPassword,
      "confirm_new_password": confirmNewPassword,
    };

    final response = await ApiService.instance.post(
      "/auth/reset-password",
      data: data,
      isProtected: false,
      showBanner: showBanner,
    );

    _isLoading = false;
    if (response != null && response.statusCode == 200) {
      context.push(
        SuccessScreen(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          buttonText: "Proceed to Login",
          mainText: "Password updated\nsuccessfully",
        ),
      );
      notifyListeners();
    } else {
      // Handle error (e.g., show a snackbar or dialog)
      notifyListeners();
    }
  }

  /// Method to upload the user's profile picture
  Future<void> uploadProfilePicture({
    required String email,
    required File profileImage,
    required BuildContext context,
    bool showBanner = true,
  }) async {
    print("API called");
    _isLoading = true;
    notifyListeners();

    try {
      // Prepare FormData
      FormData formData = FormData.fromMap({
        "email": email,
        "profileImage": await MultipartFile.fromFile(
          profileImage.path,
          filename: "profile_picture.${profileImage.path.split('.').last}",
        ),
      });

      // Make the PATCH request
      final response = await ApiService.instance.patch(
        "/auth/onboarding/upload/user/profilePicture",
        data: formData,
        isMultipart: true,
        showBanner: showBanner,
      );

      if (response != null && response.statusCode == 200) {
        // Handle successful upload
        context.push(
          SuccessScreen(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        );
      } else {}
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
