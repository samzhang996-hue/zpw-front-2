import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';
import 'package:zpw/common/view/my_web_view/zpw_my_web_view_view.dart';
import 'package:zpw/mixin/zpw_wx_mixin.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';

class ZpwCommWxLoginBottomSheet extends StatefulWidget {
  const ZpwCommWxLoginBottomSheet({super.key});

  @override
  State<ZpwCommWxLoginBottomSheet> createState() => _ZpwCommWxLoginBottomSheetState();
}

class _ZpwCommWxLoginBottomSheetState extends State<ZpwCommWxLoginBottomSheet> with ZpwWxMixin {
  late final _isCheck = false.obs;

  Widget _noCheckBottomSheet() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 30.w),
            child: Center(
              child: ZpwCommText(
                text: "服务协议与隐私保护",
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                textColor: Colors.black,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12.w),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: '我已阅读并同意', style: TextStyle(color: const Color(0xFFB3B3B3), fontSize: 11.sp)),
                            TextSpan(
                              text: '《会员协议》',
                              style: TextStyle(color: const Color(0xff676767), fontSize: 11.sp),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  String htmlStr = ZpwHandleTool.instance.hYxy;
                                  if (htmlStr.isNotEmpty) {
                                    Get.to(
                                      ZpwMyWebViewPage(
                                        titleStr: "会员协议",
                                        htmlUrl: htmlStr,
                                      ),
                                    );
                                  }
                                },
                            ),
                            TextSpan(text: '与', style: TextStyle(color: const Color(0xFFB3B3B3), fontSize: 11.sp)),
                            TextSpan(
                              text: '《隐私政策》',
                              style: TextStyle(color: const Color(0xff676767), fontSize: 11.sp),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  String htmlStr = ZpwHandleTool.instance.ySxy;
                                  if (htmlStr.isNotEmpty) {
                                    Get.to(
                                      ZpwMyWebViewPage(
                                        titleStr: "隐私政策",
                                        htmlUrl: htmlStr,
                                      ),
                                    );
                                  }
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          TapDebouncer(onTap: () async {
            Get.back(result: true);
          }, builder: (context, onTT) {
            return InkWell(
              onTap: () {
                onTT?.call();
              },
              child: Container(
                margin: EdgeInsets.only(top: 22.w, left: 16.w, right: 16.w, bottom: 20.w + ScreenUtil().bottomBarHeight),
                width: double.infinity,
                height: 52.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color(0xFF7EFAEF),
                    Color(0xFF7FE1FB),
                  ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Center(
                  child: ZpwCommText(
                    text: "同意并继续",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    textColor: const Color(0xff191919),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _onWx() async {
    if (_isCheck.value == false) {
      final result = await Get.bottomSheet<bool?>(_noCheckBottomSheet());
      if (result != true) {
        return;
      }
      _isCheck.value = true;
    }
    zpwWx();
    zpwCompleter?.future.then((v) {
      Get.back(result: v);
    }).catchError((e) {});
  }

  @override
  void dispose() {
    zpwCompleter = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 39.w),
            child: Image.asset(
              "zpw_logo.png".comm,
              width: 60.w,
              height: 60.w,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 28.w),
            child: Center(
              child: ZpwCommText(
                text: "欢迎使用Ai照片王",
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                textColor: Colors.black,
              ),
            ),
          ),
          TapDebouncer(onTap: () async {
            _onWx();
          }, builder: (context, onTT) {
            return InkWell(
              onTap: () {
                onTT?.call();
              },
              child: Container(
                margin: EdgeInsets.only(top: 22.w, left: 16.w, right: 16.w),
                width: double.infinity,
                height: 52.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color(0xFF7EFAEF),
                    Color(0xFF7FE1FB),
                  ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "zpw_wx.png".comm,
                      width: 32.w,
                      height: 32.w,
                    ),
                    SizedBox(width: 2.w),
                    ZpwCommText(
                      text: "微信登录",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      textColor: const Color(0xff191919),
                    ),
                  ],
                )),
              ),
            );
          }),
          Container(
            margin: EdgeInsets.only(top: 22.w, bottom: 20.w + ScreenUtil().bottomBarHeight),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _isCheck.toggle,
                        child: Obx(
                          () => Row(
                            children: [
                              const SizedBox(width: 3),
                              Image.asset(
                                _isCheck.value ? "zpw_wx_checked.png".comm : "zpw_wx_un_check.png".comm,
                                width: 14.w,
                              ),
                              const SizedBox(width: 3),
                              ZpwCommText(
                                text: "我已阅读并同意",
                                fontSize: 11.sp,
                                textColor: const Color(0xFFB3B3B3),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '《会员协议》',
                              style: TextStyle(color: const Color(0xff676767), fontSize: 11.sp),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  String htmlStr = ZpwHandleTool.instance.hYxy;
                                  if (htmlStr.isNotEmpty) {
                                    Get.to(
                                      ZpwMyWebViewPage(
                                        titleStr: "会员协议",
                                        htmlUrl: htmlStr,
                                      ),
                                    );
                                  }
                                },
                            ),
                            TextSpan(text: '与', style: TextStyle(color: const Color(0xFFB3B3B3), fontSize: 11.sp)),
                            TextSpan(
                              text: '《隐私政策》',
                              style: TextStyle(color: const Color(0xff676767), fontSize: 11.sp),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  String htmlStr = ZpwHandleTool.instance.ySxy;
                                  if (htmlStr.isNotEmpty) {
                                    Get.to(
                                      ZpwMyWebViewPage(
                                        titleStr: "隐私政策",
                                        htmlUrl: htmlStr,
                                      ),
                                    );
                                  }
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}