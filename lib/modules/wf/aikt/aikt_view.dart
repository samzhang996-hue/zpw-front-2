import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/base/base_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/main.dart';
import 'package:zpw/mixin/app_mixin.dart';
import 'package:zpw/model/upload_bean.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/modules/wf/aikt/view/my_slider.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zpw/utils/dowload.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:dio/src/form_data.dart' as ffff;
import 'package:dio/src/multipart_file.dart' as ffff;

class AiktPage extends StatefulWidget {
  const AiktPage({Key? key}) : super(key: key);

  @override
  State<AiktPage> createState() => _AiktPageState();
}

class _AiktPageState extends State<AiktPage> with AppMixin {
  // 原 AiktState 的状态变量
  final RxString path = "".obs;
  final RxString text = "开始扩图".obs;
  final RxDouble outPaintRatio = 0.1.obs;

  @override
  void initState() {
    super.initState();
    var map = Get.arguments;
    if (map != null) {
      path.value = map["path"] ?? "";
    }
  }

  // ============ 原 AiktLogic 的方法 ============

  Future<void> outPaint(double outPaintRatio) async {
    try {
      final formData = ffff.FormData.fromMap({
        "file": await ffff.MultipartFile.fromFile(path.value),
      });

      final uploadResponse = await HttpClient().upload<UploadBean>(
        ApiConfig.uploadFile,
        formData,
        fromJsonT: (v) => UploadBean.fromJson(v),
      );
      final bean = uploadResponse.data;

      if (bean == null) {
        HandleTool.showAppToastText("扩图失败,请重试");
        return;
      }

      final response = await HttpClient().post(
        ApiConfig.outPaint,
        data: {"imgUrls": [bean.url], "outPaintRatio": outPaintRatio},
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        text.value = "保存图片";
        final Map data = response.data as Map;
        path.value = data["returnUrl"];
        setState(() {});
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  // ============ UI 辅助方法 ============

  /// 导航栏
  Widget YAppBar(
      {String? title,
      Color? navBarTitleColor,
      Color? bgColor,
      bool canBack = true,
      bool divider = false,
      bool homePage = false,
      Widget? left,
      Widget? right,
      Widget? widget,
      String? statubar,
      double? RightValue,
      Function? leftClick,
      String? navBar,
      double rightPadding = 20,
      bool isMake = false}) {
    var screenSize = yScreenSize(navigatorKey.currentContext!);
    double statubarHeight = yStatubarHeight(navigatorKey.currentContext!);
    double navBarHeight = yNavBarHeight();
    return Container(
      color: bgColor ?? Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: screenSize.width,
            height: statubarHeight,
          ),
          Stack(children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: isMake ? 0 : 10),
              color: bgColor ?? Colors.white,
              height: navBarHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: widget == null
                    ? <Widget>[
                        if (canBack)
                          GestureDetector(
                            onTap: () {
                              if (canBack) {
                                if (leftClick != null) {
                                  leftClick();
                                } else {
                                  Get.back();
                                }
                              }
                            },
                            child: Container(
                                width: navBarHeight,
                                height: navBarHeight,
                                color: bgColor ?? Colors.white,
                                child: left ??
                                    (canBack
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                                    'arrow_back.png'.comm,
                                                    width: 16.w,
                                                    height: 16.w,
                                                    fit: BoxFit.cover,
                                                    color: navBarTitleColor ??
                                                        Colors.black)
                                                .paddingOnly(right: 10),
                                          )
                                        : Container(
                                            color: Colors.white,
                                          ))),
                          ),
                        SizedBox(
                          width: homePage == true ? 50 : 0,
                        ),
                        YTitleWidget(title ?? "",
                            navBarTitleColor: navBarTitleColor ?? Colors.black),
                        right != null
                            ? Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(right: rightPadding),
                                height: navBarHeight,
                                child: right,
                              )
                            : Container(
                                width: navBarHeight,
                              )
                      ]
                    : <Widget>[
                        SizedBox(
                            width: screenSize.width,
                            height: navBarHeight,
                            child: widget)
                      ],
              ),
            ),
          ]),
          divider
              ? Divider(height: 1, color: Colors.grey.shade400)
              : Container(),
        ],
      ),
    );
  }

  /// 页面跳转
  gotoPushPage(Widget pushWidget, {Map<String, dynamic>? arguments}) {
    Get.to(pushWidget,
        transition: Transition.rightToLeft, arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          YAppBar(
              title: "扩图",
              right: InkWell(
                  onTap: () async {
                    if ((await wxLogin() == true)) {
                      gotoPushPage(WorksPage());
                    }
                  },
                  child: CommText(
                    text: "我的作品",
                    fontSize: 13.sp,
                    textColor: Color(0xff191919),
                    fontWeight: FontWeight.bold,
                  ))),
          Obx(() {
            return text.value == "保存图片"
                ? QdsImage(path.value, 358.w, 531.w)
                : Image.file(
                    File(path.value),
                    width: 358.w,
                    height: 531.w,
                  );
          }),
          Obx(() {
            return Opacity(
              opacity: text.value == "保存图片" ? 0 : 1,
              child: Container(
                margin: EdgeInsets.only(top: 20.w, left: 16.w),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: CommText(
                      text: "比例",
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      textColor: Color(0xff191919),
                    )),
              ),
            );
          }),
          SizedBox(
            height: 10.w,
          ),
          Obx(() {
            return Opacity(
              opacity: text.value == "保存图片" ? 0 : 1,
              child: MySlider(
                onValueChanged: (value) {
                  outPaintRatio.value = value;
                },
              ),
            );
          }),
          InkWell(
            onTap: () async {
              UmengCommonSdk.onEvent('Aikt_click_event', {'name': ''});
              if ((await wxLogin() == true)) {
                if (!HandleTool.instance.isMember) {
                  gotoPushPage(VipPage());
                  return;
                }
                if (text.value == "保存图片") {
                  downloadAndSaveMedia(path.value, (res) {
                    if (res) {
                      Get.back();
                    }
                  });
                } else {
                  outPaint(outPaintRatio.value);
                }
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 26.w),
              height: 51.w,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Center(child: Obx(() {
                return CommText(
                  text: text.value,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                  textColor: Color(0xff191919),
                );
              })),
            ),
          )
        ],
      ),
    );
  }
}
