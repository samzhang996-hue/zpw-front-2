import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'comm_text/comm_text.dart';

class FaceDialog extends StatelessWidget {
  final String title;

  final String message;

  final Function() onConfirm;

  final Function()? onCancel;

  const FaceDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 310.w,
            padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 22.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              children: [
                Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                9.verticalSpace,
                Text(message, style: TextStyle(fontSize: 15.sp, color: const Color(0xFFB2B2B2))),
                20.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 36.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(68, 75, 85, 1)),
                          onPressed: () {
                            Get.back();
                            onCancel?.call();
                          },
                          child: Text('拒绝', style: TextStyle(fontSize: 16.sp, color: const Color.fromRGBO(179, 179, 179, 1), fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          onConfirm.call();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          height: 36.h,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF7EFAEF),
                                Color(0xFF7FE1FB),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            // color: const Color(0xFFFF2E7E),
                            borderRadius: BorderRadius.circular(26.w),
                          ),
                          child: Center(
                            child: CommText(
                              text: "同意",
                              textColor: const Color(0xFF191919),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                5.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
