import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/widgets/app_textfield.dart';
import 'package:student_centric_app/widgets/select_date_picker.dart';
import 'package:student_centric_app/widgets/selector_bottom_sheet.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController pronounsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController ethnicityController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Handle menu actions
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Image Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundImage: AssetImage(
                        'assets/images/profile_placeholder.png',
                      ), // Replace with your image asset
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 16.r,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              24.verticalSpace,
              // First Name
              AppTextfield.regular(
                label: "First Name",
                hintText: "Enter First Name",
                controller: firstNameController,
              ),
              16.verticalSpace,
              // Last Name
              AppTextfield.regular(
                label: "Last Name",
                hintText: "Enter Last Name",
                controller: lastNameController,
              ),
              16.verticalSpace,
              // Gender Selector
              SelectBottomSheet(
                label: "Gender",
                hintText: "Select Gender",
                items: [
                  "Male",
                  "Female",
                  "Non-Binary",
                  "Other"
                ], // Example items
                title: "Select Gender",
                controller: genderController,
              ),
              16.verticalSpace,
              // Pronouns
              AppTextfield.regular(
                label: "Pronouns",
                hintText: "Enter Pronouns",
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
                ],
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
                ],
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
            ],
          ),
        ),
      ),
    );
  }
}
