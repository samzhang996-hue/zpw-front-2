import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_widget.dart';
import 'package:zpw/common/comm_bottom_tips.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/main.dart';
import 'package:zpw/mixin/app_mixin.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/modules/wf/makewst/makewst_view.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

class WstPage extends StatefulWidget {
  const WstPage({Key? key}) : super(key: key);

  @override
  State<WstPage> createState() => _WstPageState();
}

class _WstPageState extends State<WstPage> with AppMixin {
  // 原 WstState 的状态变量
  final RxString funcValue = "".obs;
  final RxString showImgGif = "".obs;
  final RxInt funcId = 0.obs;

  @override
  void initState() {
    super.initState();
    var map = Get.arguments;
    if (map != null) {
      showImgGif.value = map["showImgGif"] ?? "";
      funcValue.value = map["funcValue"] ?? "";
      funcId.value = map["funcId"] ?? 0;
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
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          child: Stack(
            children: [
              Column(children: [
                YAppBar(
                    title: "文生图",
                    right: InkWell(
                        onTap: () async {
                          if ((await wxLogin() == true)) {
                            gotoPushPage(WorksPage());
                          }
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "my_work_ic.png".make,
                              width: 22.w,
                              height: 22.w,
                            ),
                            CommText(
                              text: "作品",
                              fontSize: 13.sp,
                              textColor: Color(0xff191919),
                              fontWeight: FontWeight.bold,
                            )
                          ],
                        ))),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Obx(() => Container(
                            margin: EdgeInsets.all(10.w),
                            child: QdsImageCorner(
                                showImgGif.value,
                                double.infinity,
                                458.w,
                                16.w,
                                fit: BoxFit.cover))),
                        Container(
                          margin: EdgeInsets.all(10.w),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xffF9F9F9),
                              borderRadius: BorderRadius.circular(16.w)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin:
                                      EdgeInsets.only(left: 13.w, top: 15.w),
                                  child: CommText(
                                    text: "提示词Prom",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                    textColor: Colors.black,
                                  )),
                              Obx(() => Container(
                                  margin: EdgeInsets.only(
                                      top: 8.w,
                                      left: 13.w,
                                      right: 13.w,
                                      bottom: 16.w),
                                  child: CommText(
                                    text: funcValue.value,
                                    fontSize: 14.sp,
                                    textColor: Color(0xff818181),
                                  )))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 80.w,
                        )
                      ],
                    ),
                  ),
                )
              ]),
              Positioned(
                bottom: 16.w,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        if ((await wxLogin() == true)) {
                          if (HandleTool.instance.isMember) {
                            gotoPushPage(MakewstPage(), arguments: {
                              "funcValue": funcValue.value,
                              "funcId": funcId.value
                            });
                          } else {
                            gotoPushPage(VipPage());
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10.w, right: 10.w),
                        width: double.infinity,
                        height: 52.w,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                            ),
                            borderRadius: BorderRadius.circular(26)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "tk.png".comm,
                              width: 26.w,
                              height: 26.w,
                            ),
                            CommText(
                              text: "做同款",
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              textColor: Color(0xff191919),
                            )
                          ],
                        ),
                      ),
                    ),
                    const CommBottomTips()
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
