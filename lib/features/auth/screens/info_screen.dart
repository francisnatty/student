// lib/features/auth/screens/info_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/auth/providers/basic_information_provider.dart';
import 'package:student_centric_app/features/auth/providers/auth_provider.dart';
import 'package:student_centric_app/features/auth/widgets/auth_appbar.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/app_textfield.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';
import 'package:student_centric_app/widgets/select_date_picker.dart';
import 'package:student_centric_app/widgets/selector_bottom_sheet.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ethnicityController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();

  final TextEditingController dateController = TextEditingController();
  bool _isChecked = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController pronounsController = TextEditingController();

  bool isButtonActive = false; // Track button state

  @override
  void initState() {
    super.initState();
    // Add listeners to controllers
    firstNameController.addListener(_validateForm);
    lastNameController.addListener(_validateForm);
    genderController.addListener(_validateForm);
    dateController.addListener(_validateForm);
    ethnicityController.addListener(_validateForm);
    religionController.addListener(_validateForm);
    maritalStatusController.addListener(_validateForm);
  }

  @override
  void dispose() {
    genderController.dispose();
    ethnicityController.dispose();
    religionController.dispose();
    maritalStatusController.dispose();
    dateController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    pronounsController.dispose();
    super.dispose();
  }

  // Method to validate form fields
  void _validateForm() {
    final isFilled = firstNameController.text.trim().isNotEmpty &&
        lastNameController.text.trim().isNotEmpty &&
        genderController.text.trim().isNotEmpty &&
        dateController.text.trim().isNotEmpty &&
        ethnicityController.text.trim().isNotEmpty &&
        religionController.text.trim().isNotEmpty &&
        maritalStatusController.text.trim().isNotEmpty &&
        _isChecked; // Assuming checkbox is required

    if (isButtonActive != isFilled) {
      setState(() {
        isButtonActive = isFilled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final basicInfoProvider = Provider.of<BasicInformationProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Text(
              "Hey 👋",
              style: TextStyle(
                fontSize: 20.sp,
              ),
            ),
            5.verticalSpace,
            Text(
              "Let’s know a little more\nabout you.",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            30.verticalSpace,
            // First Name Field
            AppTextfield.regular(
              controller: firstNameController,
              hintText: "Enter First Name",
              label: "First Name",
            ),
            16.verticalSpace,
            // Last Name Field
            AppTextfield.regular(
              controller: lastNameController,
              hintText: "Enter Last Name",
              label: "Last Name",
            ),
            16.verticalSpace,
            // Gender Selection
            SelectBottomSheet(
              label: "Gender",
              hintText: "Select Gender",
              items: ["Male", "Female", "Others"],
              title: "Select Gender",
              controller: genderController,
            ),
            5.verticalSpace,
            // Confirm Sex at Birth Checkbox
            Row(
              children: [
                Transform.scale(
                  scale: 1.4, // Adjust the scale as needed
                  child: Checkbox(
                    value: _isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isChecked = newValue ?? false;
                      });
                      _validateForm(); // Validate after checkbox change
                    },
                    // Shape with border radius
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    // Side defines the border color and width when unchecked
                    side: MaterialStateBorderSide.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          return BorderSide(
                            color:
                                AppColors.primaryColor, // Active border color
                            width: 2.0,
                          );
                        }
                        return BorderSide(
                          color:
                              AppColors.primaryColor, // Inactive border color
                          width: 1.0,
                        );
                      },
                    ),
                    // Fill color when checked
                    fillColor: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          return AppColors.primaryColor; // Active fill color
                        }
                        return Colors.transparent; // Inactive fill color
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Confirm if this is your assigned sex at birth",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            // Pronouns Field
            SelectBottomSheet(
              label: "Pronouns",
              hintText: "Select Pronouns",
              items: [
                "he/him",
                "she/her",
                "they/them",
                "ze/zir",
                "xe/xem",
                "other",
              ], // Expand as needed
              title: "Select Pronouns",
              controller: pronounsController,
            ),
            16.verticalSpace,
            // Date of Birth Picker
            SelectDatePicker(
              controller: dateController,
              hintText: "Enter DOB",
              label: "Date of Birth",
            ),
            16.verticalSpace,
            // Ethnicity Selection
            SelectBottomSheet(
              label: "Ethnicity",
              hintText: "Select Ethnicity",
              items: [
                "Native American",
                "Southeast Asian",
                "Black/African Descent",
                "East Asian",
                "Hispanic/Latino",
                "Middle Eastern",
                "Pacific Islander",
                "South Asian",
                "White/Caucasian",
                "Other",
              ], // Expand as needed
              title: "Select Ethnicity",
              controller: ethnicityController,
            ),
            16.verticalSpace,
            // Religion Selection
            SelectBottomSheet(
              label: "Religion",
              hintText: "Select Religion",
              items: [
                "Atheist",
                "Agnostic",
                "Spiritual",
                "Muslim",
                "Jewish",
                "Hindu",
                "Christian",
                "Sikh",
                "Buddhist",
                "Other",
              ], // Corrected typo
              title: "Select Religion",
              controller: religionController,
            ),
            16.verticalSpace,
            // Marital Status Selection
            SelectBottomSheet(
              label: "Marital Status",
              hintText: "Select Marital Status",
              items: [
                "Single",
                "Married",
                "Civil Partnership",
                "Separated",
                "Divorced",
                "Dissolved Civil Partnership",
                "Widowed",
                "Surviving Civil Partner",
              ],
              title: "Select Marital Status",
              controller: maritalStatusController,
            ),
            30.verticalSpace,
            // Proceed Button with Loading Indicator
            basicInfoProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : AppButton.primary(
                    isActive: isButtonActive, // Updated active state
                    isLoading: basicInfoProvider.isLoading,
                    text: "Proceed",
                    onPressed:
                        isButtonActive // Ensure button is only clickable when active
                            ? () async {
                                // Collect and validate inputs
                                final firstName =
                                    firstNameController.text.trim();
                                final lastName = lastNameController.text.trim();
                                final email = authProvider.email ?? '';
                                final gender = genderController.text.trim();
                                final confirmSexAtBirth = _isChecked;
                                final dob = dateController.text.trim();
                                final ethnicity =
                                    ethnicityController.text.trim();
                                final religious =
                                    religionController.text.trim();
                                final maritalStatus =
                                    maritalStatusController.text.trim();

                                // Call the provider's submit method
                                await basicInfoProvider.submitBasicInformation(
                                  firstName: firstName,
                                  lastName: lastName,
                                  email: email,
                                  gender: gender,
                                  confirmSexAtBirth: confirmSexAtBirth,
                                  dob: dob,
                                  ethnicity: ethnicity,
                                  religion: religious,
                                  maritalStatus: maritalStatus,
                                  context: context,
                                );
                              }
                            : null, // Disable button if not active
                  ),
            30.verticalSpace,
          ],
        ).padHorizontal,
      ),
    );
  }
}
