import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/common/view/comm_text.dart';

class CommError extends StatelessWidget {
  const CommError({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 35.w, right: 35.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      SizedBox(
                        width: 294.w,
                        height: 345.w,
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 19.w),
                          child: SizedBox(
                            width: 294.w,
                            height: 345.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 26.w),
                                Center(
                                  child: Text(
                                    '制作失败',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      color: const Color(0xFF191919),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 14.w),
                                Text(
                                  '1.可能是你的照片不符合该特效的上传要求，请参考上传建议。',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: const Color(0xFF818181),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10.w),
                                Text(
                                  '2.可能是你使用的照片违反了国家法律法规（比如明星、政治人物等等...）',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: const Color(0xFF818181),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10.w),
                                Text(
                                  'PS：请上传符合要求的照片再试试哦..',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: const Color(0xFF818181),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Get.back(result: true);
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    width: 357.w,
                                    height: 44.w,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF2E7E),
                                      borderRadius: BorderRadius.circular(26.w),
                                    ),
                                    child: Center(
                                      child: CommText(
                                        text: "重新上传",
                                        textColor: const Color(0xFFFFFFFF),
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.w),
                                GestureDetector(
                                  onTap: () {
                                    Get.back(result: false);
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    width: 357.w,
                                    height: 44.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1.w,
                                          color: const Color(0xFFFF2E7E)),
                                      borderRadius: BorderRadius.circular(26.w),
                                    ),
                                    child: Center(
                                      child: CommText(
                                        text: "知道了",
                                        textColor: const Color(0xFFFF2E7E),
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
