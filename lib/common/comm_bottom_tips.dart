import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'comm_text/comm_text.dart';

class CommBottomTips extends StatelessWidget {
  const CommBottomTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 3.w),
        CommText(
          text: "禁止利用本功能从事违法活动",
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          textColor: const Color(0xFFB2B2B2),
        ),
      ],
    );
  }
}
