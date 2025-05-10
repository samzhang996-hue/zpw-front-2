import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/qds_Image.dart';
import 'package:zpw/common/style.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/mixin/app_mixin.dart';
import 'package:zpw/modules/main/main_logic.dart';
import 'package:zpw/modules/mine/about/about_view.dart';
import 'package:zpw/modules/mine/call/call_view.dart';
import 'package:zpw/modules/mine/detail/detail_view.dart';
import 'package:zpw/modules/vip/vip_logic.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

import 'mine_logic.dart';

class MinePage extends BaseStatefulWidget {
  @override
  BaseWidgetState<MinePage> getState() => _MinePageState();
}

class _MinePageState extends BaseWidgetState<MinePage> with WidgetsBindingObserver, AppMixin, SingleTickerProviderStateMixin {
  final logic = Get.put(MineLogic());
  final state = Get.find<MineLogic>().state;

  final List<String> _tabs = ['视频', '图片'];
  late TabController _tabController;

  int _currentIndex = 0;

  Widget _animatedTab(int index, String text) {
    TextStyle normalStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16.0,
      color: Color(0xff656565),
    );
    TextStyle selectedStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 20.0,
      color: Color(0xff191919),
    );
    return Tab(
      child: AnimatedDefaultTextStyle(
        style: _currentIndex == index ? selectedStyle : normalStyle,
        duration: const Duration(milliseconds: 100),
        child: Text(text),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
    // 监听 TabController 的 index 变化
    _tabController.addListener(() {
      Log.d("msg----${_tabController.index}");
      // logic.stateIndex(_tabController.index == 0 ? 1 : 0);
      // logic.photoRecord();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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
      width: 84.w,
    );
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    return GetBuilder<MineLogic>(builder: (logic) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
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
                        margin: EdgeInsets.only(top: 80.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            image(),
                            6.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: HandleTool.instance.isNotEmpty(state.userInfoBean.nickName),
                                  child: SizedBox(
                                    width: 16.w,
                                    height: 16.w,
                                  ).paddingOnly(right: 3.w),
                                ),
                                TapDebouncer(onTap: () async {
                                  wxLogin();
                                }, builder: (context, onTT) {
                                  return GestureDetector(
                                    onTap: () {
                                      onTT?.call();
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: CommText(
                                      // text: "登录/注册",
                                      text: HandleTool.instance.isEmpty(state.userInfoBean.nickName) ? "登录/注册" : state.userInfoBean.nickName,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                                Visibility(
                                  visible: HandleTool.instance.isNotEmpty(state.userInfoBean.nickName),
                                  child: Image.asset(
                                    HandleTool.instance.isMember ? "vip_logo.png".mine : "vip_no_logo.png".mine,
                                    width: 16.w,
                                    height: 16.w,
                                    fit: BoxFit.cover,
                                  ).paddingOnly(left: 3.w),
                                )
                              ],
                            ),
                            if (HandleTool.instance.isNotEmpty(state.userInfoBean.nickName))
                              CommText(
                                text: "ID:${state.userInfoBean.id}",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                textColor: const Color(0xff666666),
                              ),
                          ],
                        ),
                      ),
                      5.verticalSpace,
                      InkWell(
                        onTap: () {
                          Get.find<VipLogic>().getVipHome();
                          gotoPushPage(VipPage());
                        },
                        child: Container(
                          width: 358.w,
                          height: 105.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("mine_vip_bg.png".mine),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 16.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommText(
                                      text: HandleTool.instance.isMember ? "尊享会员权益" : "低至¥0.01/天",
                                      fontSize: 20.sp,
                                      textColor: Color(0xff4C3504),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    9.w.verticalSpace,
                                    CommText(
                                      text: HandleTool.instance.isMember ? (state.userInfoBean.permanentFlag == 1 ? "终身有效" : "到期时间:${state.userInfoBean.vipExpireTime}") : "新用户福利",
                                      fontSize: 15.sp,
                                      textColor: Color(0xff8E691E),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Container(
                                margin: EdgeInsets.only(right: 20.w),
                                width: 82.w,
                                height: 30.w,
                                decoration: BoxDecoration(color: const Color(0xFF4C3504), borderRadius: BorderRadius.circular(16.w)),
                                child: Center(
                                    child: CommText(
                                  text: state.userInfoBean.permanentFlag == 1
                                      ? "已开通"
                                      : HandleTool.instance.isMember
                                          ? "立即续费"
                                          : "立即开通",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  textColor: const Color(0xFFFFFFFF),
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 50.w,
                  right: 16,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          gotoPushPage(CallPage());
                        },
                        child: Image.asset(
                          "kf.png".mine,
                          width: 32.w,
                        ),
                      ),
                      4.horizontalSpace,
                      InkWell(
                        onTap: () {
                          gotoPushPage(AboutPage());
                        },
                        child: Image.asset(
                          "sz.png".mine,
                          width: 32.w,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 330.w),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // margin: EdgeInsets.only(left: 8.w),
                        alignment: Alignment.center,
                        width: 1.sw * 0.3,
                        child: TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          indicatorColor: Colors.transparent,
                          tabAlignment: TabAlignment.start,
                          labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
                          dividerColor: Colors.transparent,
                          tabs: _tabs.asMap().entries.map((e) {
                            return _animatedTab(e.key, e.value);
                          }).toList(),
                          onTap: (index) {
                            // logic.stateIndex(index == 0 ? 1 : 0);
                            // logic.photoRecord();
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16.w, bottom: 10.w),
                        child: Align(
                          child: CommText(
                            text: "内容由ai生成，禁止利用本功能从事违法活动",
                            textColor: const Color(0xffCCCCCC),
                            fontSize: 10.sp,
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: NotificationListener(
                onNotification: (ScrollNotification scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification) {
                    if (scrollNotification.metrics.axisDirection == AxisDirection.right) {
                      double progress = scrollNotification.metrics.pixels / scrollNotification.metrics.maxScrollExtent;
                      double unit = 1.0 / _tabs.length;
                      int index = progress ~/ unit;
                      if (index != _currentIndex && index < _tabs.length) {
                        Log.d("msg----${_tabController.index}");
                        setState(() {
                          _currentIndex = index;
                        });
                        logic.stateIndex(index == 0 ? 1 : 0);
                        logic.photoRecord();
                      }
                    }
                  }
                  return true;
                },
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _item(),
                    _item(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _item() {
    if (state.records.value.isEmpty) {
      return Container(
        child: Column(
          children: [
            Image.asset(
              "emty_data.png".comm,
              width: 101.w,
            ),
            CommText(
              text: "暂无作品~",
              textColor: Color(0xff7C7C7C),
              fontSize: 14.sp,
            ),
            SizedBox(
              height: 13.w,
            ),
            InkWell(
              onTap: () {
                Get.back();
                Get.find<MainLogic>().changeIndex(_tabController.index);
              },
              child: Container(
                width: 122.w,
                height: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                  ),
                ),
                child: Center(
                  child: CommText(
                    text: "去创作",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    textColor: const Color(0xff191919),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w),
      child: GridView.builder(
        padding: const EdgeInsets.all(0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 175 / 265,
        ),
        shrinkWrap: true,
        itemCount: state.records.length,
        itemBuilder: (BuildContext context, int index) {
          var data = state.records[index];
          int worksStatus = data["worksStatus"] ?? 0;
          int worksType = data["worksType"] ?? 0;
          var returnUrl = data["returnUrl"] ?? "";
          var firstFrameUrl = data["firstFrameUrl"] ?? "";
          var tags = data["tags"] ?? "";
          var oldUrl = data["oldUrl"] ?? "";
          int id = data["id"] ?? 0;
          int funcId = data["funcId"] ?? 0;
          int apiType = data["apiType"] ?? 0;
          Log.d("data111--$data");
          String imagUrl;
          if ((apiType == -1 || apiType == 6)) {
            imagUrl = returnUrl;
          } else if (worksType == 1) {
            imagUrl = firstFrameUrl.toString().isEmpty ? oldUrl : firstFrameUrl;
          } else {
            imagUrl = returnUrl.toString().isEmpty ? oldUrl : returnUrl;
          }
          return InkWell(
            child: Container(
              child: Stack(
                children: [
                  QdsImageCorner(imagUrl, 175.w, 265.w, 8),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 30.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00141414), Color(0xFF73000000)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: 10.w),
                        child: CommText(
                          text: tags,
                          fontSize: 14.sp,
                          textColor: Colors.white,
                          overTextFlow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (worksStatus == 0 || worksStatus == 1 || worksStatus == 2),
                    child: Container(
                      width: 175.w,
                      height: 265.w,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xff99000000)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: (worksStatus != 2),
                            child: const CupertinoActivityIndicator(
                              color: Colors.white,
                            ),
                          ),
                          CommText(
                            text: worksStatus == 2 ? "制作失败" : "生成中...",
                            fontSize: 12.sp,
                            textColor: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                          Visibility(
                            visible: worksStatus == 2,
                            child: InkWell(
                              child: Container(
                                width: 80.w,
                                margin: EdgeInsets.only(top: 10.w),
                                height: 24.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    width: 1.w,
                                    color: ColorPlate.themeColor,
                                  ),
                                ),
                                child: Center(
                                  child: CommText(
                                    text: "重新制作",
                                    fontSize: 13.sp,
                                    textColor: ColorPlate.themeColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Log.d("xxxx----------$funcId---$id");
                                logic.getFuncDetail(funcId, id);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            onTap: () async {
              if (worksStatus == 3) {
                final res = await Get.to(() => DetailPage(), arguments: {"worksType": worksType, "returnUrl": returnUrl, "tags": tags, "id": id, "funcId": funcId, "apiType": apiType});
                logic.photoRecord();
                return;
              }
            },
          );
        },
      ),
    );
  }
}
