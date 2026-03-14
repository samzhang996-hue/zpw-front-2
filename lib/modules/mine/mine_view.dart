import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/base/zpw_base_stateful_widget.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';
import 'package:zpw/mixin/zpw_app_mixin.dart';
import 'package:zpw/modules/mine/about/about_view.dart';
import 'package:zpw/modules/mine/call/call_view.dart';
import 'package:zpw/modules/mine/setting/setting_view.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/modules/vip/vip_logic.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';

import 'mine_logic.dart';

class MinePage extends ZpwBaseStatefulWidget {
  @override
  ZpwBaseWidgetState<MinePage> getState() => _MinePageState();
}

class _MinePageState extends ZpwBaseWidgetState<MinePage> with WidgetsBindingObserver, ZpwAppMixin {
  final logic = Get.put(MineLogic());
  final state = Get.find<MineLogic>().state;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this); // 移除监听器
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        logic.getUserInfo();
        break;
      case AppLifecycleState.hidden:
      default:
        break;
    }
  }

  Widget image() {
    return Image.asset(
      "default_avatar.png".mine,
      width: 56.w,
    );
    // return state.userInfoBean.headImg == ""
    //     ? Image.asset(
    //         "default_avatar.png".mine,
    //         width: 56.w,
    //       )
    //     : ZpwQdsImageCircle(state.userInfoBean.headImg ?? "", 56.w, 56.w, isLocal: true);
  }

  @override
  Widget zpwInitDefaultBuild(BuildContext context) {
    return GetBuilder<MineLogic>(builder: (logic) {
      return Container(
        color: Color(0xffF6F6F6),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 371.w,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("mine_bg.png".mine))),
                  child: Column(
                    children: [
                      // CommHeadCircle(),
                      Container(
                        margin: EdgeInsets.only(left: 16.w, top: 67.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            image(),
                            // if(state.userInfoBean.headImg==""){
                            //   return
                            // }
                            //   ZpwQdsImageCircle(
                            //       state.userInfoBean.headImg ?? "", 56.w, 56.w,
                            //       isLocal: true),
                            // // Image.asset(
                            // //   "logo.png".mine,
                            // //   width: 56.w,
                            // // ),
                            Container(
                              margin: EdgeInsets.only(left: 7.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TapDebouncer(onTap: () async {
                                    zpwWxLogin();
                                  }, builder: (context, onTT) {
                                    return GestureDetector(
                                      onTap: () {
                                        onTT?.call();
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: ZpwCommText(
                                        // text: "登录/注册",
                                        text: ZpwHandleTool.instance.isEmpty(state.userInfoBean.nickName) ? "登录/注册" : state.userInfoBean.nickName,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }),
                                  if (ZpwHandleTool.instance.isNotEmpty(state.userInfoBean.nickName))
                                    SizedBox(
                                      height: 4.w,
                                    ),
                                  if (ZpwHandleTool.instance.isNotEmpty(state.userInfoBean.nickName))
                                    ZpwCommText(
                                      text: "ID：${state.userInfoBean.id}",
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      textColor: const Color(0xff818181),
                                    ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            if (ZpwHandleTool.instance.isNotEmpty(state.userInfoBean.nickName))
                              InkWell(
                                onTap: () {
                                  UmengCommonSdk.onEvent('Mine_click_event_setting', {'name': 'setting.png'});
                                  zpwGotoPushPage(SettingPage());
                                },
                                child: SizedBox(
                                  width: 60.w,
                                  child: Image.asset(
                                    "setting.png".mine,
                                    width: 30.w,
                                    height: 30.w,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.find<VipLogic>().getVipHome();
                          zpwGotoPushPage(VipPage());
                        },
                        child: Stack(
                          children: [
                            Image.asset(
                              "mine_vip_bg.png".mine,
                              width: 358.w,
                              height: 175.w,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 86.w,
                              left: 18.w,
                              child: ZpwCommText(
                                text: ZpwHandleTool.instance.isMember ? (state.userInfoBean.permanentFlag == 1 ? "终身有效" : "到期时间:${state.userInfoBean.vipExpireTime}") : "",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                textColor: const Color(0xFF977630),
                              ),
                            ),
                            Positioned(
                              bottom: 20.w,
                              right: 2.w,
                              child: Container(
                                margin: EdgeInsets.only(right: 20.w),
                                width: 82.w,
                                height: 30.w,
                                decoration: BoxDecoration(color: const Color(0xFF4C3504), borderRadius: BorderRadius.circular(16.w)),
                                child: Center(
                                    child: ZpwCommText(
                                  text: state.userInfoBean.permanentFlag == 1
                                      ? "已开通"
                                      : ZpwHandleTool.instance.isMember
                                          ? "立即续费"
                                          : "立即开通",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  textColor: const Color(0xFFFFFFFF),
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     Get.find<VipLogic>().getVipHome();
                      //     zpwGotoPushPage(VipPage());
                      //   },
                      //   child: Container(
                      //     margin: EdgeInsets.only(
                      //         left: 15.w, right: 17.w, top: 23.w),
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //         color: Color(0xff342D2C),
                      //         borderRadius: BorderRadius.circular(10)),
                      //     child: Container(
                      //       margin: EdgeInsets.only(left: 16.w, top: 4.w),
                      //       child: Row(
                      //         children: [
                      //           Container(
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 Row(
                      //                   children: [
                      //                     Image.asset(
                      //                       "vip_logo.png".mine,
                      //                       width: 21.w,
                      //                       height: 22.w,
                      //                     ),
                      //                     ZpwCommText(
                      //                       text: "VIP会员",
                      //                       fontSize: 22.sp,
                      //                       fontWeight: FontWeight.bold,
                      //                       textColor: Color(0xffF7C8AA),
                      //                     )
                      //                   ],
                      //                 ),
                      //                 SizedBox(
                      //                   height: 4.w,
                      //                 ),
                      //                 ZpwCommText(
                      //                   text: "海量风格模板 | 持续更新备份",
                      //                   fontSize: 14.sp,
                      //                   textColor: Color(0xffFFDEC9),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 10.w,
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //           Spacer(),
                      //           Container(
                      //             margin: EdgeInsets.only(right: 15.w),
                      //             width: 82.w,
                      //             height: 30.w,
                      //             decoration: BoxDecoration(
                      //                 gradient: LinearGradient(
                      //                   colors: [
                      //                     Color(0xffFFD9AE),
                      //                     Color(0xffEFBB94),
                      //                   ],
                      //                   begin: Alignment.topLeft,
                      //                   end: Alignment.topRight,
                      //                 ),
                      //                 borderRadius: BorderRadius.circular(20)),
                      //             child: Center(
                      //                 child: ZpwCommText(
                      //               text: ZpwHandleTool.instance.isMember
                      //                   ? "已开通"
                      //                   : "立即开通",
                      //               fontSize: 14.sp,
                      //               fontWeight: FontWeight.bold,
                      //               textColor: Color(0xff350F03),
                      //             )),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.w, right: 17.w, top: 314.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      commItem("zp.png", "我的作品"),
                      commItem("about.png", "关于我们"),
                      commItem("kf.png", "联系客服"),
                      // commItem("sf.png", "算法公式"),
                    ],
                  ),
                ),
                // ZpwCommText(
                //   text: "蜀ICP备2022002732号-3A",
                //   fontSize: 14.sp,
                //   textColor: Color(0xff818181),
                // ),
              ],
            ),
            // Container(
            //   margin: EdgeInsets.only(left: 16, right: 16, top: 20.w),
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //       color: Colors.white, borderRadius: BorderRadius.circular(12)),
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: AdBannerWidget(
            //       posId: ZpwAdsConfig.bannerId,
            //       width: 345,
            //       interval: 5,
            //       show: true,
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    });
  }

  Widget commItem(String icon, String title) {
    return InkWell(
        onTap: () async {
          UmengCommonSdk.onEvent('Mine_click_event', {'name': title});
          switch (title) {
            case "我的作品":
              // ZpwHandleTool.instance.showUpdateDialog(false, "1.1.1", "123456", "fileUrl");
              if ((await zpwWxLogin() == true)) {
                zpwGotoPushPage(WorksPage());
              }
              // zpwGotoPushPage(ZnxcPage());

              break;
            case "关于我们":
              zpwGotoPushPage(AboutPage());
              break;
            case "联系客服":
              zpwGotoPushPage(CallPage());
              break;
          }
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16.w, top: 20.w, right: 14.w),
              child: Row(
                children: [
                  Image.asset(
                    icon.mine,
                    width: 30.w,
                  ),
                  SizedBox(
                    width: 13.w,
                  ),
                  ZpwCommText(
                    text: title,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    textColor: Color(0xff191919),
                  ),
                  Spacer(),
                  Image.asset(
                    "arrow.png".mine,
                    width: 15.w,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 0.5,
              color: Color(0xffF3F3F3),
              margin: EdgeInsets.only(left: 15.w, top: 20.w, right: 15.w),
            ),
          ],
        ));
  }
}
