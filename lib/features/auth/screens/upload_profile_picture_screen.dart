import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/core/storage/secure_store.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/features/auth/providers/auth_provider.dart';
import 'package:student_centric_app/features/auth/widgets/auth_appbar.dart';
import 'package:student_centric_app/widgets/app_button.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';

import 'login_screen.dart';

class UploadProfilePictureScreen extends StatefulWidget {
  const UploadProfilePictureScreen({super.key});

  @override
  State<UploadProfilePictureScreen> createState() =>
      _UploadProfilePictureScreenState();
}

class _UploadProfilePictureScreenState
    extends State<UploadProfilePictureScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  /// Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  /// Method to handle the upload process
  Future<void> _handleUpload() async {
    if (_imageFile == null) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final storage = SecureStorage();
    String? email = await storage.get(key: 'email');

    await authProvider.uploadProfilePicture(
      email: email!,
      profileImage: _imageFile!,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: const AuthAppbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            Text(
              "Add a profile\npicture",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            80.verticalSpace,
            Center(
              child: CircleAvatar(
                radius: 90.r,
                backgroundColor: AppColors.primaryFour,
                backgroundImage:
                    _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null
                    ? SvgPicture.asset(AppAssets.profileIconLarge)
                    : null,
              ),
            ),
            140.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: AppButton.primary(
                isLoading: authProvider.isLoading,
                isActive: true,
                text: _imageFile == null ? "Add Picture" : "Proceed",
                onPressed: () async {
                  print('dresak');
                  if (_imageFile == null) {
                    print("Here");
                    _pickImage();
                  } else {
                    print("Here2");
                    final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                    final storage = SecureStorage();
                    String? email = await storage.get(key: 'email')??'test@gmail.com';
                    debugPrint("email is $email");

                    await authProvider.uploadProfilePicture(
                      email: email,
                      profileImage: _imageFile!,
                      context: context,
                    );

                  }
                },
              ),
            ),
            10.verticalSpace,

          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: AppButton.primary(
                isLoading: false,
                text: 'Skip',
                isActive: true,
                backgroundColor: Colors.white,
                textColor: AppColors.primaryColor,
                onPressed: (){
                  print("deana");
                  debugPrint("delay ===> ");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ),
          ],
        ).padHorizontal,
      ),
    );
  }
}
