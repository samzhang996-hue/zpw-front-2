import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zpw/common/constant.dart';

class NoMoreContentView extends StatelessWidget {
  const NoMoreContentView({super.key});

  Widget _leftImg() {
    return Container(
      width: 13.w,
      height: 2.w,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.w),
        Row(
          children: [
            const Spacer(),
            Image.asset(
              "no_more_content_left.png".face,
              width: 13.w,
              height: 2.w,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 4.w),
            Text(
              "没有更多内容了哦",
              style: TextStyle(
                color: const Color(0xFFB2B2B2),
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 4.w),
            Image.asset(
              "no_more_content_right.png".face,
              width: 13.w,
              height: 2.w,
              fit: BoxFit.cover,
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
