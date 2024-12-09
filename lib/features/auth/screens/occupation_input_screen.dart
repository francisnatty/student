// lib/features/auth/screens/occupation_input_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/features/auth/providers/basic_information_provider.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/app_textfield.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';
import 'package:student_centric_app/widgets/selector_bottom_sheet.dart';

class OccupationInputScreen extends StatefulWidget {
  const OccupationInputScreen({super.key});

  @override
  State<OccupationInputScreen> createState() => _OccupationInputScreenState();
}

class _OccupationInputScreenState extends State<OccupationInputScreen> {
  final TextEditingController industryController = TextEditingController();
  final TextEditingController specialtyController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();

  // Method to check if all fields are filled
  bool get areAllFieldsFilled {
    return industryController.text.isNotEmpty &&
        specialtyController.text.isNotEmpty &&
        jobTitleController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BasicInformationProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Text(
              "Enter Occupation\nInformation",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            30.verticalSpace,
            SelectBottomSheet(
              label: "Industry",
              hintText: "Select Industry",
              items: const [
                "Education",
                "Technology",
                "Social Media/Networking",
                "Productivity",
                "Finance",
                "Health & Wellness",
                "Entertainment",
                "Gaming",
                "Retail/E-commerce",
                "Lifestyle",
                "Travel",
                "Food & Drink",
                "News/Media",
                "Non-Profit",
                "Art & Design",
                "Science",
                "Sports/Fitness",
                "Real Estate",
                "Transportation",
                "Legal",
              ],
              title: "Select Industry",
              controller: industryController,
              onSelected: (value) {
                setState(() {}); // Update button state
              },
            ),
            16.verticalSpace,
            SelectBottomSheet(
              label: "Specialty",
              hintText: "Select Specialty",
              items: const [
                "Academic Support",
                "STEM (Science, Technology, Engineering, Mathematics)",
                "Arts & Humanities",
                "Business & Finance",
                "Law",
                "Medicine & Health Sciences",
                "Social Sciences",
                "Language Learning",
                "Design & Creative Arts",
                "Engineering",
                "Environmental Studies",
                "Marketing & Advertising",
                "Psychology & Counseling",
                "Data Science & Analytics",
                "Education Technology (EdTech)",
                "Entrepreneurship",
                "Public Policy & Government",
                "Sports Management",
                "Music & Performing Arts",
                "Human Resources & Recruitment",
                "Culinary Arts",
                "Media & Communications",
                "Fashion & Beauty",
                "Sustainability & Green Technologies",
                "Project Management",
              ],
              title: "Select Specialty",
              controller: specialtyController,
              onSelected: (value) {
                setState(() {}); // Update button state
              },
            ),
            16.verticalSpace,
            AppTextfield.regular(
              hintText: "Enter Job Title",
              label: "Job Title",
              controller: jobTitleController,
              onChanged: (value) {
                setState(() {}); // Update button state
              },
            ),
            30.verticalSpace,
            AppButton.primary(
              isActive:
                  areAllFieldsFilled, // Enable button only if fields are filled
              isLoading: provider.isLoading,
              text: "Proceed",
              onPressed: areAllFieldsFilled
                  ? () {
                     print("log here");
                     debugPrint("log there........");
                      provider.submitOccupationInformation(
                        industry: industryController.text,
                        specialty: specialtyController.text,
                        jobTitle: jobTitleController.text,
                        context: context,
                      );
                    }
                  : null, // Disable onPressed when not active
            ),
            30.verticalSpace,
          ],
        ).padHorizontal,
      ),
    );
  }

  @override
  void dispose() {
    industryController.dispose();
    specialtyController.dispose();
    jobTitleController.dispose();
    super.dispose();
  }
}
