import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/view/comm_text.dart';

class CommSuccess extends StatelessWidget {
  final String headImg;
  const CommSuccess({super.key, required this.headImg});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: 118.w,
          width: 358.w,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 7,
                spreadRadius: 0,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(width: 12.w),
                  Stack(
                    children: [
                      Container(
                        width: 69.w,
                        height: 94.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD8D8D8),
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.w),
                          child: QdsImage(
                            headImg,
                            69.w,
                            94.w,
                          ),
                        ),
                      ),
                      Container(
                        width: 69.w,
                        height: 94.w,
                        decoration: BoxDecoration(
                          color: const Color(0xA3191919),
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                        child: Center(
                          child: CommText(
                            text: "制作中",
                            textColor: const Color(0xFFFFFFFF),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CommText(
                            text: "作品正在制作中！",
                            textColor: const Color(0xff191919),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          // Image.asset(
                          //   "make_result_success.png".make,
                          //   width: 26.w,
                          //   height: 26.w,
                          // ),
                        ],
                      ),
                      SizedBox(height: 9.w),
                      CommText(
                        text: "制作完成即可在我的作品中查看",
                        textColor: const Color(0xFF818181),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      // Row(
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () {
                      //         _show.value = false;
                      //       },
                      //       behavior: HitTestBehavior.opaque,
                      //       child: Container(
                      //         width: 110.w,
                      //         height: 33.w,
                      //         decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           border: Border.all(
                      //               width: 1.w,
                      //               color: const Color(0xFFFF2E7E)),
                      //           borderRadius:
                      //               BorderRadius.circular(26.w),
                      //         ),
                      //         child: Center(
                      //           child: CommText(
                      //             text: "稍后查看",
                      //             textColor: const Color(0xFFFF2E7E),
                      //             fontSize: 15.sp,
                      //             fontWeight: FontWeight.w500,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(width: 14.w),
                      //     GestureDetector(
                      //       onTap: () {
                      //         _show.value = false;
                      //         _toHistory();
                      //       },
                      //       behavior: HitTestBehavior.opaque,
                      //       child: Container(
                      //         width: 110.w,
                      //         height: 33.w,
                      //         decoration: BoxDecoration(
                      //           color: const Color(0xFFFF2E7E),
                      //           borderRadius:
                      //               BorderRadius.circular(26.w),
                      //         ),
                      //         child: Center(
                      //           child: CommText(
                      //             text: "立即查看",
                      //             textColor: const Color(0xFFFFFFFF),
                      //             fontSize: 15.sp,
                      //             fontWeight: FontWeight.w500,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
