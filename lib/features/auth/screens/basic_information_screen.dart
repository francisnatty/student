import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/core/utils/bottom_sheets.dart';
import 'package:student_centric_app/features/auth/providers/basic_information_provider.dart';
import 'package:student_centric_app/features/auth/screens/address_input_screen.dart';
import 'package:student_centric_app/features/auth/screens/info_screen.dart';
import 'package:student_centric_app/features/auth/screens/occupation_input_screen.dart';
import 'package:student_centric_app/features/auth/screens/school_details_input_screen.dart';
import 'package:student_centric_app/features/auth/widgets/auth_appbar.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';

class BasicInformationScreen extends StatelessWidget {
  const BasicInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BasicInformationProvider>(
      create: (_) => BasicInformationProvider(),
      child: Scaffold(
        appBar: AuthAppbar(
          onPressed: () {},
        ),
        body: Consumer<BasicInformationProvider>(
          builder: (context, pageProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.verticalSpace,
                // SmoothPageIndicator added here
                SmoothPageIndicator(
                  controller: pageProvider.pageController,
                  count: 4,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8.0,
                    dotWidth: 16.0,
                    activeDotColor: AppColors.primaryColor,
                    dotColor: AppColors.primaryFour,
                  ),
                ).padHorizontal,
                // Adding some spacing between the indicator and the PageView
                const SizedBox(height: 16.0),

                // Expanded widget wraps PageView to take remaining space
                Expanded(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: pageProvider.pageController,
                    onPageChanged: (index) {
                      pageProvider.setPage(index);
                    },
                    children: const [
                      InfoScreen(),
                      AddressInputScreen(),
                      SchoolDetailsInputScreen(),
                      OccupationInputScreen(),
                    ],
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
