import 'package:flutter/material.dart';
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/ads_config.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/modules/mine/about/about_view.dart';
import 'package:zpw/modules/mine/call/call_view.dart';
import 'package:zpw/modules/mine/setting/setting_view.dart';
import 'package:zpw/modules/mine/works/works_view.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/utils/handle_tool.dart';

import 'mine_logic.dart';

class MinePage extends BaseStatefulWidget {
  @override
  BaseWidgetState<MinePage> getState() => _MinePageState();
}

class _MinePageState extends BaseWidgetState<MinePage>
    with WidgetsBindingObserver {
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
  Widget image(){
    return state.userInfoBean.headImg==""?
    Image.asset(
      "logo.png".mine,
      width: 56.w,
    ):   QdsImageCircle(
        state.userInfoBean.headImg ?? "", 56.w, 56.w,
        isLocal: true);
  }
  @override
  Widget initDefaultBuild(BuildContext context) {
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
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("mine_bg.png".mine))),
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
                            //   QdsImageCircle(
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
                                  CommText(
                                    text: state.userInfoBean.nickName,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: 4.w,
                                  ),
                                  CommText(
                                    text: HandleTool.instance.isMember
                                        ? (state.userInfoBean.permanentFlag == 0
                                            ? "永久会员"
                                            : "到期时间:${state.userInfoBean.vipExpireTime}")
                                        : "未开通会员",
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    textColor: Color(0xff818181),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                gotoPushPage(SettingPage());
                              },
                              child: Container(
                                  width: 60.w,
                                  child: Image.asset(
                                    "setting.png".mine,
                                    width: 30.w,
                                    height: 30.w,
                                  )),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          gotoPushPage(VipPage());
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 15.w, right: 17.w, top: 23.w),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xff342D2C),
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            margin: EdgeInsets.only(left: 16.w, top: 4.w),
                            child: Row(
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "vip_logo.png".mine,
                                            width: 21.w,
                                            height: 22.w,
                                          ),
                                          CommText(
                                            text: "VIP会员",
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.bold,
                                            textColor: Color(0xffF7C8AA),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4.w,
                                      ),
                                      CommText(
                                        text: "海量风格模板 | 持续更新备份",
                                        fontSize: 14.sp,
                                        textColor: Color(0xffFFDEC9),
                                      ),
                                      SizedBox(
                                        height: 10.w,
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  margin: EdgeInsets.only(right: 15.w),
                                  width: 82.w,
                                  height: 30.w,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xffFFD9AE),
                                          Color(0xffEFBB94),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.topRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: CommText(
                                    text: HandleTool.instance.isMember
                                        ? "已开通"
                                        : "立即开通",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    textColor: Color(0xff350F03),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.w, right: 17.w, top: 232.w),
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
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 20.w),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AdBannerWidget(
                  posId: AdsConfig.bannerId,
                  width: 345,
                  interval: 5,
                  show: true,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget commItem(String icon, String title) {
    return InkWell(
        onTap: () {
          switch (title) {
            case "我的作品":
              gotoPushPage(WorksPage());
              break;
            case "关于我们":
              gotoPushPage(AboutPage());
              break;
            case "联系客服":
              gotoPushPage(CallPage());
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
                  CommText(
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
