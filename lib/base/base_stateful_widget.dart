// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_widget.dart';
import 'package:zpw/common/style.dart';
import 'package:zpw/main.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  @override
  BaseWidgetState createState() => getState();

  BaseWidgetState getState();
}

abstract class BaseWidgetState<T extends BaseStatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Color backgroundColor = ColorPlate.themeBgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Scaffold(
            backgroundColor: backgroundColor,
            body: SafeArea(
              top: false,
              bottom: false,
              child: Container(
                // padding: EdgeInsets.only(top: yStatubarHeight(context)+10),
                child: initDefaultBuild(context),
              ),
            )),
        onTap: () => yCloseInputMethod());
  }

  ///界面构建
  Widget initDefaultBuild(BuildContext context);

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
                                        ? Icon(Icons.arrow_back_ios,
                                            color: navBarTitleColor ??
                                                Colors.black)
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
  gotoOffPage(Widget pushWidget, {Map<String, dynamic>? arguments}) {
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

  void yCloseInputMethod() {
    BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }
}
