import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/features/auth/providers/auth_provider.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/app_textfield.dart';
import 'package:student_centric_app/widgets/password_criteria.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final PasswordValidation _passwordValidation = PasswordValidation();

  final ValueNotifier<bool> _minLengthMet = ValueNotifier(false);
  final ValueNotifier<bool> _upperLowerCaseMet = ValueNotifier(false);
  final ValueNotifier<bool> _numberMet = ValueNotifier(false);
  final ValueNotifier<bool> _specialCharMet = ValueNotifier(false);

  bool get isConfirmPasswordValid =>
      _passwordController.text == _confirmPasswordController.text &&
      _confirmPasswordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
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
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _minLengthMet.dispose();
    _upperLowerCaseMet.dispose();
    _numberMet.dispose();
    _specialCharMet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    bool isFormValid = _minLengthMet.value &&
        _upperLowerCaseMet.value &&
        _numberMet.value &&
        _specialCharMet.value &&
        isConfirmPasswordValid &&
        !authProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Change\nPassword",
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    20.verticalSpace,
                    AppTextfield.password(
                      label: "New Password",
                      hintText: "Enter New Password",
                      controller: _passwordController,
                    ),
                    15.verticalSpace,
                    Column(
                      children: [
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
                            SizedBox(width: 14.w),
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
                      hintText: "Re-enter Password",
                      controller: _confirmPasswordController,
                    ),
                    40.verticalSpace,
                    AppButton.primary(
                      text: "Proceed",
                      isActive: isFormValid,
                      isLoading: authProvider.isLoading,
                      onPressed: isFormValid
                          ? () {
                              authProvider.resetPassword(
                                newPassword: _passwordController.text.trim(),
                                confirmNewPassword:
                                    _confirmPasswordController.text.trim(),
                                context: context,
                              );
                            }
                          : null,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
