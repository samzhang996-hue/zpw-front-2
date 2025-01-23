import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';

class CustomFaceDialogUtils {
  static void showCustomDialog({
    required Function() onPressed,
  }) {
    Get.dialog(
      StatefulBuilder(// 使用 StatefulBuilder 包裹对话框内容
          builder: (context, setState) {
        return Center(
          child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Center(
                        child: Container(
                          width: 318.w,
                          height: 332.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      Container(
                        width: 318.w,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 26.w,
                            ),
                            Image.asset(
                              "facecheck.png".comm,
                              width: 126.w,
                            ),
                            SizedBox(
                              height: 16.w,
                            ),
                            CommText(
                              text: "未检测到人脸",
                              fontSize: 20.sp,
                              textColor: Color(0xff333333),
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 4.w,
                            ),
                            CommText(
                              text: "请重新选择一张包含人脸的照片制作",
                              fontSize: 14.sp,
                              textColor: Color(0xffB2B2B2),
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              height: 20.w,
                            ),
                            InkWell(
                              child: Container(
                                margin: EdgeInsets.only(top: 20.h),
                                width: 256.w,
                                height: 43.h,
                                decoration: BoxDecoration(
                                    color: Color(0xffFF2E7E),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                    child: CommText(
                                  text: "重选照片",
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  textColor: Colors.white,
                                )),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                onPressed();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
      }),
      barrierDismissible: false,
    );

    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return StatefulBuilder(// 使用 StatefulBuilder 包裹对话框内容
    //         builder: (context, setState) {
    //           return Center(
    //             child: Material(
    //                 color: Colors.transparent,
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Stack(
    //                       alignment: Alignment.topCenter,
    //                       children: [
    //                         Center(
    //                           child: Container(
    //                             width: 318.w,
    //                             height: 332.w,
    //                             decoration: BoxDecoration(
    //                                 color: Colors.white,
    //                                 borderRadius: BorderRadius.circular(12)),
    //                           ),
    //                         ),
    //                         Container(
    //                           width: 318.w,
    //                           child: Column(
    //                             children: [
    //                               SizedBox(height: 26.w,),
    //                               Image.asset("facecheck.png".comm,width: 126.w,),
    //                               SizedBox(height: 16.w,),
    //                               CommText(text: "未检测到人脸",fontSize: 20.sp,textColor: Color(0xff333333),fontWeight: FontWeight.bold,),
    //                               SizedBox(height: 4.w,),
    //                               CommText(text: "请重新选择一张包含人脸的照片制作",fontSize: 14.sp,textColor: Color(0xffB2B2B2),fontWeight: FontWeight.w500,),
    //                               SizedBox(height: 20.w,),
    //                               InkWell(
    //                                 child: Container(
    //                                   margin: EdgeInsets.only(top: 20.h),
    //                                   width: 256.w,
    //                                   height: 43.h,
    //                                   decoration: BoxDecoration(
    //                                       color: Color(0xffFF2E7E),
    //                                       borderRadius: BorderRadius.circular(30)),
    //                                   child: Center(
    //                                       child: CommText(
    //                                         text: "重选照片",
    //                                         fontSize: 18.sp,
    //                                         fontWeight: FontWeight.bold,
    //                                         textColor: Colors.white,
    //                                       )),
    //                                 ),
    //                                 onTap: () {
    //                                   Navigator.of(context).pop();
    //                                   onPressed();
    //                                 },
    //                               )
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 )),
    //           );
    //         });
    //   },
    // );
  }
}
