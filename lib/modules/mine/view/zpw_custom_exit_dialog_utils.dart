import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';
import 'package:zpw/common/view/my_web_view/zpw_my_web_view_view.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';

class ZpwCustomExitDialogUtils {
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
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        Container(
                          width: 318.w,
                          child: Column(
                            children: [
                              Container(
                                child: ZpwCommText(
                                  text: "注销账号",
                                  textColor: Color(0xff191919),
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center,
                                ),
                                margin: EdgeInsets.only(top: 26.h),
                              ),
                              Container(
                                margin: EdgeInsets.all(20),
                                child: ZpwCommText(
                                  text: "所有相关数据将被删除并无法找回，确定要删除账号吗？",
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  textColor: Color(0xff818181),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(17.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      child: Container(
                                        width: 124.w,
                                        height: 44.h,
                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          width: 1.w,
                                          color: Color(0xff191919)
                                        )),
                                        child: Center(
                                            child: ZpwCommText(
                                          text: "取消",
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500,
                                          textColor: Color(0xff191919),
                                        )),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    InkWell(
                                      child: Container(
                                        width: 124.w,
                                        height: 44.h,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.topRight,
                                            ),
                                            borderRadius: BorderRadius.circular(30)),
                                        child: Center(
                                            child: ZpwCommText(
                                          text: "确定",
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500,
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
