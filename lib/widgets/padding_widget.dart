import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension PaddingExtension on Widget {
  Padding get padHorizontal => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: this,
      );
}
