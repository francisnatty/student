// lib/features/auth/screens/address_input_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/auth/providers/basic_information_provider.dart';
import 'package:student_centric_app/features/auth/widgets/auth_appbar.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/app_textfield.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';
import 'package:student_centric_app/widgets/selector_bottom_sheet.dart';

class AddressInputScreen extends StatefulWidget {
  const AddressInputScreen({super.key});

  @override
  State<AddressInputScreen> createState() => _AddressInputScreenState();
}

class _AddressInputScreenState extends State<AddressInputScreen> {
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Listen for changes in the countryController to fetch cities
    countryController.addListener(_onCountrySelected);
    // final provider =
    //     Provider.of<BasicInformationProvider>(context, listen: false)
    //         .fetchCountries();
  }

  @override
  void dispose() {
    countryController.removeListener(_onCountrySelected);
    countryController.dispose();
    cityController.dispose();
    streetController.dispose();
    zipCodeController.dispose();
    super.dispose();
  }

  void _onCountrySelected() {
    final provider =
        Provider.of<BasicInformationProvider>(context, listen: false);
    final selectedCountryName = countryController.text;

    // Find the selected country object
    final selectedCountry = provider.countries.firstWhere(
      (country) => country.name == selectedCountryName,
    );

    if (selectedCountry != null) {
      // Fetch cities for the selected country
      provider.fetchCities(selectedCountry:selectedCountry);
      debugPrint("get cities from county ${selectedCountry.name}");
      // Clear the city selection

      cityController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<BasicInformationProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter\nHouse Address",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 30.h),
              // Country Selector
              SelectBottomSheet(
                label: "Country",
                hintText: "Select Country",
                items: pageProvider.countries
                    .map((country) => country.name??'')
                    .toList(),
                title: "Select Country",
                controller: countryController,
                isLoading: pageProvider.isCountriesLoading,
              ),
              SizedBox(height: 16.h),
              // City Selector
              SelectBottomSheet(
                label: "City",
                hintText: "Select City",
                items: pageProvider.cities.map((city) => city.name??'').toList(),
                title: "Select City",
                controller: cityController,
                isLoading: pageProvider.isCitiesLoading,
              ),
              SizedBox(height: 16.h),
              AppTextfield.regular(
                hintText: "Enter Street",
                label: "Street",
                controller: streetController,
              ),
              SizedBox(height: 16.h),
              AppTextfield.regular(
                hintText: "Enter Zip Code",
                label: "Zip Code",
                controller: zipCodeController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 30.h),
              AppButton.primary(
                text: "Proceed",
                onPressed: () {
                  // Handle form submission or navigation
                  pageProvider.nextPage();
                },
              ),
              SizedBox(height: 30.h),
              // Display error messages if any
              if (pageProvider.countriesError != null)
                Text(
                  pageProvider.countriesError!,
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                ),
              if (pageProvider.citiesError != null)
                Text(
                  pageProvider.citiesError!,
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
