import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:student_centric_app/core/utils/validators.dart';
import 'package:student_centric_app/features/auth/providers/auth_provider.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/core/utils/bottom_sheets.dart';
import 'package:student_centric_app/features/auth/screens/login_screen.dart';
import 'package:student_centric_app/features/auth/widgets/email_verification.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/app_textfield.dart';
import 'package:student_centric_app/widgets/password_criteria.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final PasswordValidation _passwordValidation = PasswordValidation();
  final ValueNotifier<bool> _minLengthMet = ValueNotifier(false);
  final ValueNotifier<bool> _upperLowerCaseMet = ValueNotifier(false);
  final ValueNotifier<bool> _numberMet = ValueNotifier(false);
  final ValueNotifier<bool> _specialCharMet = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
    _emailController.addListener(() {
      setState(() {});
    });
    _confirmPasswordController.addListener(() {
      setState(() {});
    });
  }

  void _validatePassword() {
    String password = _passwordController.text;
    _minLengthMet.value = _passwordValidation.hasMinLength(password);
    _upperLowerCaseMet.value = _passwordValidation.hasUpperLowerCase(password);
    _numberMet.value = _passwordValidation.hasNumber(password);
    _specialCharMet.value = _passwordValidation.hasSpecialCharacter(password);
    setState(() {}); // Update UI when password changes
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _minLengthMet.dispose();
    _upperLowerCaseMet.dispose();
    _numberMet.dispose();
    _specialCharMet.dispose();
    super.dispose();
  }

  bool get isFormValid {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text &&
        _minLengthMet.value &&
        _upperLowerCaseMet.value &&
        _numberMet.value &&
        _specialCharMet.value;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    final isActive = isFormValid;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    35.verticalSpace,
                    AppTextfield.regular(
                      label: "Email Address",
                      hintText: "Enter Email Address",
                      controller: _emailController,
                      validator: validateEmail,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Requires email with school domain only \n(e.g jon@coventryuniversity.com)",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.blackFour,
                      ),
                    ),
                    20.verticalSpace,
                    AppTextfield.password(
                      label: "Password",
                      hintText: "Enter Password",
                      controller: _passwordController,
                    ),
                    15.verticalSpace,
                    Column(
                      children: [
                        // First Row of Password Criteria
                        Row(
                          children: [
                            ValueListenableBuilder<bool>(
                              valueListenable: _minLengthMet,
                              builder: (context, isMet, child) =>
                                  PasswordCriteria(
                                isMet: isMet,
                                label: "At least 8 characters",
                              ),
                            ),
                            SizedBox(width: 10.w),
                            ValueListenableBuilder<bool>(
                              valueListenable: _upperLowerCaseMet,
                              builder: (context, isMet, child) =>
                                  PasswordCriteria(
                                isMet: isMet,
                                label: "Both uppercase & lowercase",
                              ),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        // Second Row of Password Criteria
                        Row(
                          children: [
                            ValueListenableBuilder<bool>(
                              valueListenable: _numberMet,
                              builder: (context, isMet, child) =>
                                  PasswordCriteria(
                                isMet: isMet,
                                label: "At least one number",
                              ),
                            ),
                            14.horizontalSpace,
                            Expanded(
                              child: ValueListenableBuilder<bool>(
                                valueListenable: _specialCharMet,
                                builder: (context, isMet, child) =>
                                    PasswordCriteria(
                                  isMet: isMet,
                                  label: "At least 1 special character",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    AppTextfield.password(
                      label: "Confirm Password",
                      hintText: "Enter Password",
                      controller: _confirmPasswordController,
                    ),
                    SizedBox(height: 30.h),
                    AppButton.primary(
                      text: "Get Started",
                      isActive: isActive,
                      isLoading: isLoading,
                      onPressed: isActive && !isLoading
                          ? () async {
                              final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);

                              await authProvider.signUp(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                                confirmPassword:
                                    _confirmPasswordController.text,
                                showBanner: true,
                                context: context,
                              );
                            }
                          : null,
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          context.push(LoginScreen());
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.greyOne,
                            ),
                            children: [
                              TextSpan(
                                text: 'Have an account? ',
                              ),
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
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
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'Clicking continue shows that you agree to our ',
                  ),
                  TextSpan(
                    text: 'Terms and\nConditions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' while interacting with our platform.',
                  ),
                ],
              ),
            ),
            30.verticalSpace,
          ],
        ),
      ),
    );
  }
}
