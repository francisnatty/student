import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectorLoader extends StatelessWidget {
  const SelectorLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20.h,
          width: 20.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
          ),
        ),
      ],
    );
  }
}
