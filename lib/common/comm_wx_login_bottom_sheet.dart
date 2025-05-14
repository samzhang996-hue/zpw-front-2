import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/common/view/my_web_view/my_web_view_view.dart';
import 'package:zpw/mixin/wx_mixin.dart';
import 'package:zpw/utils/handle_tool.dart';

import '../modules/gameplay/gameplay_logic.dart';
import '../modules/main/model/user_info_bean.dart';
import '../modules/mine/mine_logic.dart';
import '../network/api/network_api.dart';
import '../utils/sp_utils.dart';

class CommWxLoginBottomSheet extends StatefulWidget {
  const CommWxLoginBottomSheet({super.key});

  @override
  State<CommWxLoginBottomSheet> createState() => _CommWxLoginBottomSheetState();
}

class _CommWxLoginBottomSheetState extends State<CommWxLoginBottomSheet> with WxMixin {
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
              child: CommText(
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
                                  String htmlStr = HandleTool.instance.hYxy;
                                  if (htmlStr.isNotEmpty) {
                                    Get.to(
                                      MyWebViewPage(
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
                                  String htmlStr = HandleTool.instance.ySxy;
                                  if (htmlStr.isNotEmpty) {
                                    Get.to(
                                      MyWebViewPage(
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
                  child: CommText(
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
    Wx();
    completer?.future.then((v) {
      Get.back(result: v);
    }).catchError((e) {});
  }

  Future<void> _onIos() async {
    if (_isCheck.value == false) {
      final result = await Get.bottomSheet<bool?>(_noCheckBottomSheet());
      if (result != true) {
        return;
      }
      _isCheck.value = true;
    }
    EasyLoading.show();
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      if (credential.identityToken == null) {
        EasyLoading.dismiss();
        Get.back();
      } else {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        HandleTool.instance.SMWPost(Api.authorizeByIos, isShowProgress: true, params: {
          'identityToken': credential.identityToken,
          'aud': packageInfo.packageName,
          'userDeviceInfo': await HandleTool.instance.getMap(),
        }, success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            HandleTool.showAppToastText('登录成功');
            Map data = results.first as Map;
            SpUtils.setString("token", data['token'] ?? "");
            HandleTool.instance.token = data['token'] ?? "";
            HandleTool.instance.SMWPost<UserInfoBean>(Api.sso_getUserInfo,
                isShowProgress: true,
                success: (isSuccess, code, message, results) {
                  if (isSuccess == true && results.isNotEmpty) {
                    final mineLogic = Get.find<MineLogic>();
                    mineLogic.state.userInfoBean = results.first;
                    HandleTool.instance.isMember = mineLogic.state.userInfoBean.vipFlag == 1;
                    final logic = Get.find<GameplayLogic>();
                    logic.stateShowVip(HandleTool.instance.isMember);
                    mineLogic.update();
                    EasyLoading.dismiss();
                    Get.back();
                  } else {
                    EasyLoading.dismiss();
                    Get.back();
                  }
                },
                onModel: (m) => UserInfoBean.fromJson(m));
          }
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  @override
  void dispose() {
    completer = null;
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
              "logo.png".comm,
              width: 60.w,
              height: 60.w,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 28.w),
            child: Center(
              child: CommText(
                text: "欢迎使用Ai照片王",
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                textColor: Colors.black,
              ),
            ),
          ),
          Obx(() => Visibility(
                visible: isInstalled.isTrue,
                child: TapDebouncer(onTap: () async {
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
                            "wx.png".comm,
                            width: 32.w,
                            height: 32.w,
                          ),
                          SizedBox(width: 2.w),
                          CommText(
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
              )),
          if (Platform.isIOS)
            TapDebouncer(onTap: () async {
              await _onIos();
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
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: Colors.black, width: 1.w),
                  ),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "ios.png".comm,
                        width: 32.w,
                        height: 32.w,
                      ),
                      SizedBox(width: 2.w),
                      CommText(
                        text: "苹果登录",
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
                                _isCheck.value ? "wx_checked.png".comm : "wx_un_check.png".comm,
                                width: 14.w,
                              ),
                              const SizedBox(width: 3),
                              CommText(
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
                                  String htmlStr = HandleTool.instance.hYxy;
                                  if (htmlStr.isNotEmpty) {
                                    Get.to(
                                      MyWebViewPage(
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
                                  String htmlStr = HandleTool.instance.ySxy;
                                  if (htmlStr.isNotEmpty) {
                                    Get.to(
                                      MyWebViewPage(
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
