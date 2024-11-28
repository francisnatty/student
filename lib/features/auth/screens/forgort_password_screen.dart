import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/features/auth/providers/auth_provider.dart';
import 'package:student_centric_app/features/auth/widgets/auth_appbar.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/app_textfield.dart';

class ForgortPasswordScreen extends StatefulWidget {
  const ForgortPasswordScreen({super.key});

  @override
  _ForgortPasswordScreenState createState() => _ForgortPasswordScreenState();
}

class _ForgortPasswordScreenState extends State<ForgortPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isEmailValid = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateEmail);
  }

  void _validateEmail() {
    setState(() {
      isEmailValid =
          RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text);
    });
  }

  @override
  void dispose() {
    emailController.removeListener(_validateEmail);
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: const AuthAppbar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    Text(
                      "Forgot\nPassword",
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    60.verticalSpace,
                    AppTextfield.regular(
                      label: "Email Address",
                      hintText: "Enter Email Address",
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                    40.verticalSpace,
                    AppButton.primary(
                      isActive: isEmailValid,
                      isLoading: authProvider.isLoading,
                      text: "Proceed",
                      onPressed: isEmailValid && !authProvider.isLoading
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                authProvider.forgotPassword(
                                  email: emailController.text.trim(),
                                  context: context,
                                );
                              }
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          30.verticalSpace,
        ],
      ),
    );
  }
}
