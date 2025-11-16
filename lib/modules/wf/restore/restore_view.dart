import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/main.dart';
import 'package:zpw/mixin/app_mixin.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/my_plugin.dart';
import 'package:zpw/utils/permission.dart';

class RestorePage extends StatefulWidget {
  const RestorePage({Key? key}) : super(key: key);

  @override
  State<RestorePage> createState() => _RestorePageState();
}

class _RestorePageState extends State<RestorePage> with AppMixin {
  // ============ UI 辅助方法 ============

  onStartPhoto() async {
    await PermissionUtils.checkFilesAccessPermission();
    startPhoto();
  }

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
          YAppBar(title: "数据恢复"),
          Image.asset(
            "hf.png".comm,
            width: double.infinity,
            height: 297.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "left_bg.png".comm,
                width: 27.w,
                height: 2.w,
              ),
              SizedBox(
                width: 2.w,
              ),
              CommText(
                text: "数据恢复 安全可靠",
                fontWeight: FontWeight.bold,
                textColor: Color(0xff191919),
                fontSize: 19.sp,
              ),
              SizedBox(
                width: 2.w,
              ),
              Image.asset(
                "right_bg.png".comm,
                width: 27.w,
                height: 2.w,
              ),
            ],
          ),
          CommText(
            text: "数据不会在服务器上保存‌，仅存于本地设备",
            textColor: Color(0xff999999),
            fontSize: 13.sp,
          ),
          InkWell(
            onTap: () async {
              if ((await wxLogin() == true)) {
                if (HandleTool.instance.isMember) {
                  onStartPhoto();
                } else {
                  gotoPushPage(VipPage());
                }
              }
            },
            child: Container(
              height: 51.w,
              width: double.infinity,
              margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 26.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Center(
                  child: CommText(
                text: "立即恢复",
                textColor: Color(0xff191919),
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              )),
            ),
          ),
          SizedBox(
            height: 27.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Image.asset(
                    "del.png".comm,
                    width: 56.w,
                    height: 56.w,
                  ),
                  SizedBox(
                    height: 4.w,
                  ),
                  CommText(
                    text: "误删",
                    fontSize: 14.sp,
                    textColor: Color(0xff191919),
                  )
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    "clean.png".comm,
                    width: 56.w,
                    height: 56.w,
                  ),
                  SizedBox(
                    height: 4.w,
                  ),
                  CommText(
                    text: "回收站清空",
                    fontSize: 14.sp,
                    textColor: Color(0xff191919),
                  )
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    "data.png".comm,
                    width: 56.w,
                    height: 56.w,
                  ),
                  SizedBox(
                    height: 4.w,
                  ),
                  CommText(
                    text: "数据丢失",
                    fontSize: 14.sp,
                    textColor: Color(0xff191919),
                  )
                ],
              ),
              Column(
                children: [
                  Image.asset(
                    "dir.png".comm,
                    width: 56.w,
                    height: 56.w,
                  ),
                  SizedBox(
                    height: 4.w,
                  ),
                  CommText(
                    text: "目录损坏",
                    fontSize: 14.sp,
                    textColor: Color(0xff191919),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
