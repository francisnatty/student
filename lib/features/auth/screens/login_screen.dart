// lib/features/auth/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart'; // Ensure you have provider added
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/auth/providers/auth_provider.dart';
import 'package:student_centric_app/features/auth/screens/forgort_password_screen.dart';
import 'package:student_centric_app/features/auth/screens/sign_up_screen.dart';
import 'package:student_centric_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/app_textfield.dart';
import 'package:student_centric_app/widgets/password_criteria.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(); // Added controller
  final TextEditingController _passwordController = TextEditingController();
  final PasswordValidation _passwordValidation = PasswordValidation();
  final ValueNotifier<bool> _minLengthMet = ValueNotifier(false);
  final ValueNotifier<bool> _upperLowerCaseMet = ValueNotifier(false);
  final ValueNotifier<bool> _numberMet = ValueNotifier(false);
  final ValueNotifier<bool> _specialCharMet = ValueNotifier(false);

  final _formKey = GlobalKey<FormState>(); // For form validation

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    String password = _passwordController.text;
    _minLengthMet.value = _passwordValidation.hasMinLength(password);
    _upperLowerCaseMet.value = _passwordValidation.hasUpperLowerCase(password);
    _numberMet.value = _passwordValidation.hasNumber(password);
    _specialCharMet.value = _passwordValidation.hasSpecialCharacter(password);
  }

  @override
  void dispose() {
    _emailController.dispose(); // Dispose email controller
    _passwordController.dispose();
    _minLengthMet.dispose();
    _upperLowerCaseMet.dispose();
    _numberMet.dispose();
    _specialCharMet.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 20.h), // Added padding
                  child: Form(
                    key: _formKey, // Assign form key
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 35.h),
                        AppTextfield.regular(
                          label: "Email Address",
                          hintText: "Enter Email Address",
                          controller: _emailController, // Use controller
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            // Simple email validation
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),
                        AppTextfield.password(
                          label: "Password",
                          hintText: "Enter Password",
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 5.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ForgortPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        AppButton.primary(
                          text: "Login",
                          isActive: true,
                          isLoading: authProvider.isLoggingIn, // Show loading
                          onPressed: authProvider.isLoggingIn
                              ? null
                              : _handleLogin, // Disable if loading
                        ),
                        SizedBox(height: 40.h),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.greyOne,
                                ), // Default font size and color
                                children: const [
                                  TextSpan(
                                    text: 'Don’t have an account?',
                                  ),
                                  TextSpan(
                                    text: ' Sign up',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ), // Bold style for Sign up
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (authProvider.isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
