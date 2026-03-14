// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zpw/main.dart';

int zpwLastClickTime = 0;

///获取屏幕尺寸
Size zpwYScreenSize(BuildContext context) => MediaQuery.of(context).size;

double zpwYSpaceH(BuildContext context, h) =>
    h * MediaQuery.of(context).size.height / 844;

///获取状态栏高度
double zpwYStatubarHeight(BuildContext context) =>
    MediaQuery.of(context).padding.top;

///获取导航条高度
double zpwYNavBarHeight() {
  MediaQueryData mediaQuery = MediaQuery.of(navigatorKey.currentContext!);
  double statusHeight = mediaQuery.padding.top;
  double navHeight = 50;
  // Log.i("mediaQuery=====${statusHeight} ${AppBar().preferredSize.height}");
  return Platform.isAndroid ? (navHeight) : navHeight;
}

double zpwYNavBarStatusHeight() {
  MediaQueryData mediaQuery = MediaQuery.of(navigatorKey.currentContext!);
  double statusHeight = mediaQuery.padding.top;
  double navHeight = AppBar().preferredSize.height;
  // Log.i("mediaQuery=====${statusHeight} ${AppBar().preferredSize.height}");
  return Platform.isAndroid ? (navHeight + statusHeight) : navHeight;
}

///标题组件
Expanded ZpwYTitleWidget(String title, {Color navBarTitleColor = Colors.black}) {
  return Expanded(
      child: Center(
          child: Text(title ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: navBarTitleColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500))));
}

Widget zpwWSpace(double w) => SizedBox(
      width: w,
    );
Widget zpwHSpace(double h) => SizedBox(
      height: h,
    );

///占位组件
Widget ZpwYEmptyContainer() => const Offstage(offstage: true, child: Text(""));