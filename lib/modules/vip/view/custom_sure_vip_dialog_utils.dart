import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';
import 'package:zpw/common/view/my_web_view/zpw_my_web_view_view.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';

class CustomSureVipDialogUtils {
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
                            height: 219.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        Container(
                          width: 318.w,
                          child: Column(
                            children: [
                              Container(
                                  margin:
                                      EdgeInsets.only(top: 13.h, right: 13.w),
                                  width: 318.w,
                                  child: InkWell(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Image.asset(
                                        "zpw_close.png".vip,
                                        width: 30.w,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      // Get.back();
                                    },
                                  )),
                              Container(
                                child: ZpwCommText(
                                  text: "确认开通",
                                  textColor: Color(0xff1A1A1A),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(top: 19.h),
                                  width: 238.w,
                                  child: Column(
                                    children: [
                                      Text.rich(TextSpan(children: [
                                        const TextSpan(
                                            text: '我已阅读并同意',
                                            style: TextStyle(
                                                color: Color(0xff7E7E7E),
                                                fontSize: 14)),
                                        TextSpan(
                                          text: '《会员协议》',
                                          style: const TextStyle(
                                              color: Color(0xff676767),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              String htmlStr =
                                                  ZpwHandleTool.instance.hYxy;
                                              if (htmlStr.length > 0) {
                                                Get.to(
                                                  ZpwMyWebViewPage(
                                                    titleStr: "会员协议",
                                                    htmlUrl: htmlStr,
                                                  ),
                                                );
                                              }
                                            },
                                        ),
                                        const TextSpan(
                                            text: ',确认开通该套餐.',
                                            style: TextStyle(
                                                color: Color(0xff7E7E7E),
                                                fontSize: 14)),
                                      ]))
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(top: 20.h),
                                  width: 256.w,
                                  height: 43.h,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.topRight,
                                      ),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                      child: ZpwCommText(
                                    text: "继续开通",
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    textColor: Color(0xff191919),
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
