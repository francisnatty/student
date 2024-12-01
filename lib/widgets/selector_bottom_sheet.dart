// lib/widgets/select_bottom_sheet.dart

import 'dart:math'; // Import for min function
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_textfield.dart'; // Ensure the correct import path
import 'package:student_centric_app/core/utils/app_colors.dart';

class SelectBottomSheet extends StatefulWidget {
  final String? label;
  final String hintText;
  final List<String> items;
  final String title;
  final TextEditingController? controller;
  final bool isLoading;
  final ValueChanged<String>? onSelected; // Added onSelected callback

  const SelectBottomSheet({
    super.key,
    this.label,
    required this.hintText,
    required this.items,
    required this.title,
    this.controller,
    this.isLoading = false,
    this.onSelected,
  });

  @override
  _SelectBottomSheetState createState() => _SelectBottomSheetState();
}

class _SelectBottomSheetState extends State<SelectBottomSheet> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    // Initialize _selectedItem with the controller's text if available
    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      _selectedItem = widget.controller!.text;
    }
  }

  void _showBottomSheet() {
    if (widget.isLoading) {
      // Optionally, prevent opening the bottom sheet while loading
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      isScrollControlled: true,
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final maxHeight = screenHeight * 0.7; // 70% of screen height
        final itemHeight = 64.h + 16.h; // Item height + vertical margins

        // Calculate total height required for all items
        final listHeight = widget.items.length * itemHeight;

        // Fixed heights: top padding + title row + spacing + bottom padding
        final fixedHeight = 20.h + 48.h + 35.h + 20.h;

        // Total desired height
        final totalHeight = fixedHeight + listHeight;

        // Final height is the minimum of totalHeight and maxHeight
        final containerHeight = min(totalHeight, maxHeight);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          height: containerHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              // Title and Close Button
              Row(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: AppColors.greyAlt,
                      radius: 24.r,
                      child: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              35.verticalSpace,
              // List of items
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    final isSelected = _selectedItem == item;
                    return GestureDetector(
                      onTap: () {
                        if (widget.controller != null) {
                          widget.controller!.text = item;
                        }
                        setState(() {
                          _selectedItem = item;
                        });
                        Navigator.pop(context); // Close the bottom sheet
                        if (widget.onSelected != null) {
                          widget.onSelected!(
                              item); // Call the onSelected callback
                        }
                      },
                      child: Container(
                        height: 64.h,
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryThree
                              : AppColors.primaryFour,
                          borderRadius: BorderRadius.circular(64.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              20.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppTextfield.regular(
      label: widget.label,
      hintText: widget.hintText,
      controller: widget.controller,
      readOnly: true,
      onTap: _showBottomSheet,
      suffixIcon: widget.isLoading
          ? SizedBox(
              width: 24.w,
              height: 24.h,
              child: Transform.scale(
                scale: 0.5,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              ),
            )
          : const Icon(
              Icons.keyboard_arrow_down_outlined,
              color: Colors.black,
            ),
      keyboardType: TextInputType.text,
    );
  }
}
