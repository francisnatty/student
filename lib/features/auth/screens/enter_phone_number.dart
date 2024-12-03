// enter_phone_number.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart'; // Ensure Provider is imported
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/core/utils/bottom_sheets.dart';
import 'package:student_centric_app/features/auth/providers/auth_provider.dart'; // Import AuthProvider
import 'package:student_centric_app/features/auth/widgets/auth_appbar.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/app_textfield.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';

class EnterPhoneNumberScreen extends StatefulWidget {
  const EnterPhoneNumberScreen({super.key});

  @override
  _EnterPhoneNumberScreenState createState() => _EnterPhoneNumberScreenState();
}

class _EnterPhoneNumberScreenState extends State<EnterPhoneNumberScreen> {
  String selectedCountryCode = "+1"; // Default country code
  String selectedFlag = "🇺🇸"; // Default flag
  final TextEditingController _phoneController = TextEditingController();
// Expanded list of countries with names, including more African countries
  final List<Map<String, String>> countryCodes = [
    // North America
    {"code": "+1", "flag": "🇺🇸", "name": "United States"},
    {"code": "+1", "flag": "🇨🇦", "name": "Canada"},
    {"code": "+1", "flag": "🇯🇲", "name": "Jamaica"},
    // Europe
    {"code": "+44", "flag": "🇬🇧", "name": "United Kingdom"},
    {"code": "+49", "flag": "🇩🇪", "name": "Germany"},
    {"code": "+33", "flag": "🇫🇷", "name": "France"},
    {"code": "+39", "flag": "🇮🇹", "name": "Italy"},
    {"code": "+7", "flag": "🇷🇺", "name": "Russia"},
    // Asia
    {"code": "+91", "flag": "🇮🇳", "name": "India"},
    {"code": "+81", "flag": "🇯🇵", "name": "Japan"},
    {"code": "+86", "flag": "🇨🇳", "name": "China"},
    // Oceania
    {"code": "+61", "flag": "🇦🇺", "name": "Australia"},
    {"code": "+64", "flag": "🇳🇿", "name": "New Zealand"},
    // Africa
    {"code": "+213", "flag": "🇩🇿", "name": "Algeria"},
    {"code": "+216", "flag": "🇹🇳", "name": "Tunisia"},
    {"code": "+218", "flag": "🇱🇾", "name": "Libya"},
    {"code": "+220", "flag": "🇬🇲", "name": "Gambia"},
    {"code": "+221", "flag": "🇸🇳", "name": "Senegal"},
    {"code": "+222", "flag": "🇸🇳", "name": "Mauritania"},
    {"code": "+223", "flag": "🇲🇱", "name": "Mali"},
    {"code": "+224", "flag": "🇸🇱", "name": "Sierra Leone"},
    {"code": "+225", "flag": "🇨🇮", "name": "Côte d'Ivoire"},
    {"code": "+226", "flag": "🇧🇫", "name": "Burkina Faso"},
    {"code": "+227", "flag": "🇳🇪", "name": "Niger"},
    {"code": "+228", "flag": "🇹🇬", "name": "Togo"},
    {"code": "+229", "flag": "🇧🇯", "name": "Benin"},
    {"code": "+230", "flag": "🇲🇺", "name": "Mauritius"},
    {"code": "+231", "flag": "🇱🇷", "name": "Liberia"},
    {"code": "+232", "flag": "🇸🇱", "name": "Sierra Leone"},
    {"code": "+233", "flag": "🇬🇭", "name": "Ghana"},
    {"code": "+234", "flag": "🇳🇬", "name": "Nigeria"},
    {"code": "+235", "flag": "🇨🇲", "name": "Chad"},
    {"code": "+236", "flag": "🇨🇫", "name": "Central African Republic"},
    {"code": "+237", "flag": "🇨🇲", "name": "Cameroon"},
    {"code": "+238", "flag": "🇨🇻", "name": "Cape Verde"},
    {"code": "+239", "flag": "🇸🇹", "name": "São Tomé and Principe"},
    {"code": "+240", "flag": "🇬🇶", "name": "Equatorial Guinea"},
    {"code": "+241", "flag": "🇬🇦", "name": "Gabon"},
    {"code": "+242", "flag": "🇨🇬", "name": "Republic of the Congo"},
    {
      "code": "+243",
      "flag": "🇨🇩",
      "name": "Democratic Republic of the Congo"
    },
    {"code": "+244", "flag": "🇦🇴", "name": "Angola"},
    {"code": "+245", "flag": "🇬🇼", "name": "Guinea-Bissau"},
    {"code": "+246", "flag": "🇹🇰", "name": "Tristan da Cunha"},
    {"code": "+247", "flag": "🇸🇭", "name": "Ascension Island"},
    {"code": "+248", "flag": "🇸🇨", "name": "Seychelles"},
    {"code": "+249", "flag": "🇸🇩", "name": "Sudan"},
    {"code": "+250", "flag": "🇷🇼", "name": "Rwanda"},
    {"code": "+251", "flag": "🇪🇹", "name": "Ethiopia"},
    {"code": "+252", "flag": "🇸🇴", "name": "Somalia"},
    {"code": "+253", "flag": "🇩🇯", "name": "Djibouti"},
    {"code": "+254", "flag": "🇰🇪", "name": "Kenya"},
    {"code": "+255", "flag": "🇹🇿", "name": "Tanzania"},
    {"code": "+256", "flag": "🇺🇬", "name": "Uganda"},
    {"code": "+257", "flag": "🇧🇯", "name": "Burundi"},
    {"code": "+258", "flag": "🇲🇿", "name": "Mozambique"},
    {"code": "+260", "flag": "🇿🇲", "name": "Zambia"},
    {"code": "+261", "flag": "🇲🇬", "name": "Madagascar"},
    {"code": "+262", "flag": "🇾🇹", "name": "Mayotte"},
    {"code": "+263", "flag": "🇿🇼", "name": "Zimbabwe"},
    {"code": "+264", "flag": "🇳🇦", "name": "Namibia"},
    {"code": "+265", "flag": "🇲🇼", "name": "Malawi"},
    {"code": "+266", "flag": "🇱🇸", "name": "Lesotho"},
    {"code": "+267", "flag": "🇧🇼", "name": "Botswana"},
    {"code": "+268", "flag": "🇲🇺", "name": "Eswatini"},
    {"code": "+269", "flag": "🇰🇲", "name": "Comoros"},
    {"code": "+27", "flag": "🇿🇦", "name": "South Africa"},
    {"code": "+290", "flag": "🇸🇭", "name": "Saint Helena"},
    {"code": "+291", "flag": "🇪🇷", "name": "Eritrea"},
    {"code": "+297", "flag": "🇦🇼", "name": "Aruba"},
    {"code": "+298", "flag": "🇫🇴", "name": "Faroe Islands"},
    {"code": "+299", "flag": "🇬🇱", "name": "Greenland"},
  ];

  void _showCountryPicker() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        TextEditingController _searchController = TextEditingController();
        List<Map<String, String>> filteredCountryCodes =
            List.from(countryCodes);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 700.h, // Adjust the height as needed
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with Title and Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Your Country",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 16.r,
                          backgroundColor: AppColors.greyAlt,
                          child: Icon(
                            Icons.close,
                            size: 18.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Search TextField
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setModalState(() {
                        filteredCountryCodes = countryCodes.where((country) {
                          final countryName = country['name']!.toLowerCase();
                          return countryName.contains(value.toLowerCase());
                        }).toList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search country',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Divider(
                    thickness: 1,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16.h),
                  // List of Countries
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCountryCodes.length,
                      itemBuilder: (context, index) {
                        final country = filteredCountryCodes[index];
                        return ListTile(
                          leading: Text(
                            country["flag"] ?? "",
                            style: TextStyle(fontSize: 24.sp),
                          ),
                          title: Text(
                            country["name"] ?? "",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          subtitle: Text(
                            country["code"] ?? "",
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.grey),
                          ),
                          onTap: () {
                            setState(() {
                              selectedCountryCode = country["code"]!;
                              selectedFlag = country["flag"]!;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthProvider>(context); // Access AuthProvider

    return Scaffold(
      appBar: AuthAppbar(),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 16.w), // Adjust padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Text(
              "Enter\nPhone Number",
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            50.verticalSpace,
            Row(
              children: [
                // Country picker as a read-only text field
                SizedBox(
                  width: 140.w, // Adjust width as needed
                  child: AppTextfield.regular(
                    controller: TextEditingController(
                        text: "$selectedFlag $selectedCountryCode"),
                    readOnly: true,
                    onTap: _showCountryPicker,
                    // Optionally, add an icon to indicate it's a dropdown
                    suffixIcon:
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                    hintText: '',
                    // Customize the appearance to match your text fields
                  ),
                ),
                SizedBox(width: 10.w),
                // Phone number text field
                Expanded(
                  flex: 5, // Adjust flex as needed
                  child: AppTextfield.regular(
                    controller: _phoneController,
                    hintText: "Enter Phone Number",
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            TextButton(
              onPressed: () {
                // Optionally, handle what happens if the number changes
              },
              child: Text(
                "What if my number changes?",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            Spacer(), // Spacer pushes the next widget to the bottom
            authProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : AppButton.primary(
                    text: "Proceed",
                    onPressed: () async {
                      final email = authProvider.email;
                      final phoneNumber =
                          "$selectedCountryCode${_phoneController.text.trim()}";

                      if (email == null || email.isEmpty) {
                        // Handle missing email
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Email is missing. Please sign up again."),
                          ),
                        );
                        return;
                      }

                      if (_phoneController.text.trim().isEmpty) {
                        // Handle empty phone number
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please enter a valid phone number."),
                          ),
                        );
                        return;
                      }

                      // Call the provider method to add phone number
                      await authProvider.addPhoneNumber(
                        email: email,
                        phoneNumber: phoneNumber,
                        context: context,
                      );
                    },
                  ),
            20.verticalSpace, // Add some space below the button for better spacing
          ],
        ),
      ),
    );
  }
}
