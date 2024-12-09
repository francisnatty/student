import 'package:flutter/material.dart';
import 'app_textfield.dart'; // Ensure the correct import path
import 'package:student_centric_app/core/utils/app_colors.dart';

class SelectDatePicker extends StatefulWidget {
  final String? label;
  final String hintText;
  final TextEditingController? controller;

  const SelectDatePicker({
    super.key,
    this.label,
    required this.hintText,
    this.controller,
  });

  @override
  _SelectDatePickerState createState() => _SelectDatePickerState();
}

class _SelectDatePickerState extends State<SelectDatePicker> {
  DateTime? _selectedDate;

  Future<void> _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.white, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        if (widget.controller != null) {
          widget.controller!.text = "${pickedDate.toLocal()}".split(' ')[0];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextfield.regular(
      label: widget.label,
      hintText: widget.hintText,
      controller: widget.controller,
      readOnly: true, // Make the text field read-only
      onTap: _showDatePicker, // Trigger date picker on tap
      suffixIcon: const Icon(
        Icons.calendar_today_outlined,
        color: AppColors.blackThree,
      ), // Calendar icon
      keyboardType: TextInputType.text,
    );
  }
}
