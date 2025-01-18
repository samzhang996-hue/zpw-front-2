import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/common/view/my_web_view/my_web_view_view.dart';
import 'package:zpw/utils/handle_tool.dart';

class CustomPhotoDialogUtils {
  static void showCustomDialog({
    required BuildContext context,
    required Function() onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(// 使用 StatefulBuilder 包裹对话框内容
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
                            height: 360.h,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        Container(
                          width: 318.w,
                          child: Column(
                            children: [
                              Container(
                                child: CommText(
                                  text: "温馨提示",
                                  textColor: Color(0xff1A1A1A),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.center,
                                ),
                                margin: EdgeInsets.only(top: 26.h),
                              ),
                              Container(
                                margin: EdgeInsets.all(13),
                                child: CommText(
                                  text: "1.视频换脸技术类似视频版PS技术，利用人脸图像和视频结合。人脸照片在视频合成后会立即删除，不会保留你的人脸照片数据。\n\n2.请确保你使用的照片获得本人授权同意，严禁使用未获得本人授权同意的照片。如因照片为授权对他人肖像权造成侵犯所产生的法律责任由本人承担。\n\n3.严禁使用涉黄照片和视频。",
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  textColor: Color(0xff818181),
                                ),
                              ),
                              InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(left: 27.w,right: 27.w),
                                  width: double.infinity,
                                  height: 44.h,
                                  decoration: BoxDecoration(color: Color(0xffFF2E7E), borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                      child: CommText(
                                        text: "确定",
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
        });
      },
    );
  }
}
