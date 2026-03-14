// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_widget.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/zpw_style.dart';
import 'package:zpw/main.dart';

abstract class ZpwBaseStatefulWidget extends StatefulWidget {
  @override
  ZpwBaseWidgetState createState() => getState();

  ZpwBaseWidgetState getState();
}

abstract class ZpwBaseWidgetState<T extends ZpwBaseStatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Color zpwBackgroundColor = ZpwColorPlate.zpwThemeBgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Scaffold(
            backgroundColor: zpwBackgroundColor,
            body: SafeArea(
              top: false,
              bottom: false,
              child: Container(
                // padding: EdgeInsets.only(top: zpwYStatubarHeight(context)+10),
                child: zpwInitDefaultBuild(context),
              ),
            )),
        onTap: () => zpwYCloseInputMethod());
  }

  ///界面构建
  Widget zpwInitDefaultBuild(BuildContext context);

  /// 导航栏
  Widget zpwYAppBar(
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
    var screenSize = zpwYScreenSize(navigatorKey.currentContext!);
    double statubarHeight = zpwYStatubarHeight(navigatorKey.currentContext!);
    double navBarHeight = zpwYNavBarHeight();
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
                                        //  Icon(Icons.arrow_back_ios,
                                        //     color: navBarTitleColor ??
                                        //         Colors.black)
                                        : Container(
                                            color: Colors.white,
                                          ))),
                          ),
                        SizedBox(
                          width: homePage == true ? 50 : 0,
                        ),
                        ZpwYTitleWidget(title ?? "",
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
  zpwGotoPushPage(Widget pushWidget, {Map<String, dynamic>? arguments}) {
    // Get.to(() => pushWidget,transition: Transition.rightToLeft,arguments: arguments );
    // if (pushWidget is NewVipPage &&
    //     (HandleTool.instance.channel == "jl2" ||
    //         HandleTool.instance.channel == "ks2")) {
    //   Get.to(DyVipPage(),
    //       transition: Transition.rightToLeft, arguments: arguments);
    //   return;
    // }
    Get.to(pushWidget,
        transition: Transition.rightToLeft, arguments: arguments);
  }

  /// 页面跳转
  zpwGotoOffPage(Widget pushWidget, {Map<String, dynamic>? arguments}) {
    // if (pushWidget is NewVipPage &&
    //     (HandleTool.instance.channel == "jl2" ||
    //         HandleTool.instance.channel == "ks2")) {
    //   Get.off(DyVipPage(),
    //       transition: Transition.rightToLeft, arguments: arguments);
    //   return;
    // }
    Get.off(pushWidget,
        transition: Transition.rightToLeft, arguments: arguments);
  }

  void zpwYCloseInputMethod() {
    BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }
}