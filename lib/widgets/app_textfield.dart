import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';

class AppTextfield extends StatefulWidget {
  final String? label;
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon; // Added prefixIcon property
  final VoidCallback? onTap;
  final bool readOnly;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged; // 1. Added onChanged parameter

  // Regular constructor for non-password fields
  const AppTextfield.regular({
    super.key,
    this.label,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon, // Initialize prefixIcon for regular textfield
    this.onTap,
    this.readOnly = false,
    this.validator,
    this.onChanged, // 2. Include onChanged in regular constructor
  }) : isPassword = false;

  // Password constructor with obscuring enabled
  const AppTextfield.password({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onChanged, // 2. Include onChanged in password constructor
  })  : isPassword = true,
        suffixIcon = null,
        prefixIcon = null, // Prefix icon not applicable for password field
        onTap = null,
        readOnly = false;

  @override
  _AppTextfieldState createState() => _AppTextfieldState();
}

class _AppTextfieldState extends State<AppTextfield> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    // Add listener to the controller if it's not null
    widget.controller?.addListener(_onControllerTextChanged);
  }

  @override
  void dispose() {
    // Remove listener when the widget is disposed
    widget.controller?.removeListener(_onControllerTextChanged);
    super.dispose();
  }

  void _onControllerTextChanged() {
    // Trigger a rebuild when the controller's text changes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label == null
            ? const SizedBox.shrink()
            : Text(
                widget.label ?? "",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
              ),
        widget.label == null ? const SizedBox.shrink() : 8.verticalSpace,
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          style: const TextStyle(
            color: Colors.black,
          ),
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          onChanged: widget.onChanged, // 3. Pass onChanged to TextFormField
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: AppColors.blackFour,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF7E93A0),
              ),
              borderRadius: BorderRadius.circular(64.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(64.r),
            ),
            prefixIcon: widget.prefixIcon, // Add prefixIcon to InputDecoration
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
