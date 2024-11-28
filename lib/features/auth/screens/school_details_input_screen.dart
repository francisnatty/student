// lib/features/auth/screens/school_details_input_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/features/auth/providers/basic_information_provider.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';
import 'package:student_centric_app/widgets/selector_bottom_sheet.dart';

class SchoolDetailsInputScreen extends StatefulWidget {
  const SchoolDetailsInputScreen({Key? key}) : super(key: key);

  @override
  State<SchoolDetailsInputScreen> createState() =>
      _SchoolDetailsInputScreenState();
}

class _SchoolDetailsInputScreenState extends State<SchoolDetailsInputScreen> {
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController programTypeController = TextEditingController();
  final TextEditingController courseOfStudyController = TextEditingController();
  final TextEditingController yearInSchoolController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<BasicInformationProvider>(context, listen: false);
    provider.fetchSchools();
  }

  // Getter to check if all fields are filled
  bool get areAllFieldsFilled {
    return schoolNameController.text.isNotEmpty &&
        programTypeController.text.isNotEmpty &&
        courseOfStudyController.text.isNotEmpty &&
        yearInSchoolController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<BasicInformationProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Text(
              "Enter School\nInformation",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            30.verticalSpace,
            // School Name Selector
            SelectBottomSheet(
              label: "School Name",
              hintText: "Select School",
              items: pageProvider.schools.map((e) => e.schoolName).toList(),
              title: "Select School",
              controller: schoolNameController,
              isLoading: pageProvider.isSchoolsLoading,
              onSelected: (value) {
                final selectedSchool = pageProvider.schools
                    .firstWhere((e) => e.schoolName == value);
                pageProvider.setSelectedSchoolId(selectedSchool.id);
                pageProvider.fetchProgramTypes(selectedSchool.id);
                // Clear subsequent selections
                programTypeController.clear();
                courseOfStudyController.clear();
                yearInSchoolController.clear();
                pageProvider.resetSelections(from: 'school');
                setState(() {}); // Update UI
              },
            ),
            16.verticalSpace,
            // Program Type Selector
            SelectBottomSheet(
              label: "Program Type",
              hintText: "Select Program Type",
              items: pageProvider.programTypes.map((e) => e.name).toList(),
              title: "Select Program Type",
              controller: programTypeController,
              isLoading: pageProvider.isProgramTypesLoading,
              onSelected: (value) {
                final selectedProgramType = pageProvider.programTypes
                    .firstWhere((e) => e.name == value);
                pageProvider.setSelectedProgramTypeId(selectedProgramType.id);
                pageProvider.fetchCourses(
                  pageProvider.selectedSchoolId!,
                  selectedProgramType.id,
                );
                // Clear subsequent selections
                courseOfStudyController.clear();
                yearInSchoolController.clear();
                pageProvider.resetSelections(from: 'programType');
                setState(() {}); // Update UI
              },
            ),
            16.verticalSpace,
            // Course of Study Selector
            SelectBottomSheet(
              label: "Course of Study",
              hintText: "Select Course",
              items: pageProvider.courses.map((e) => e.courseName).toList(),
              title: "Select Course",
              controller: courseOfStudyController,
              isLoading: pageProvider.isCoursesLoading,
              onSelected: (value) {
                final selectedCourse = pageProvider.courses
                    .firstWhere((e) => e.courseName == value);
                pageProvider.setSelectedCourseId(selectedCourse.id);
                pageProvider.fetchYears();
                // Clear subsequent selections
                yearInSchoolController.clear();
                pageProvider.resetSelections(from: 'course');
                setState(() {}); // Update UI
              },
            ),
            16.verticalSpace,
            // Year in School Selector
            SelectBottomSheet(
              label: "Year in School",
              hintText: "Select Year",
              items: pageProvider.years.map((e) => e.name).toList(),
              title: "Select Year",
              controller: yearInSchoolController,
              isLoading: pageProvider.isYearsLoading,
              onSelected: (value) {
                final selectedYear =
                    pageProvider.years.firstWhere((e) => e.name == value);
                pageProvider.setSelectedYearId(selectedYear.id);
                setState(() {}); // Update UI
              },
            ),
            30.verticalSpace,
            AppButton.primary(
              isActive: areAllFieldsFilled,
              isLoading: pageProvider.isLoading,
              text: "Proceed",
              onPressed: areAllFieldsFilled
                  ? () {
                      pageProvider.submitSchoolInformation(
                        schoolName: schoolNameController.text,
                        programType: programTypeController.text,
                        courseOfStudy: courseOfStudyController.text,
                        yearInSchool: yearInSchoolController.text,
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
    schoolNameController.dispose();
    programTypeController.dispose();
    courseOfStudyController.dispose();
    yearInSchoolController.dispose();
    super.dispose();
  }
}
