import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/mixin/app_mixin.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

import 'mine_logic.dart';

/// 垃圾类1：迷惑型函数
class _FakeLogicHelper {
  int _counter = 0;
  final Random _rnd = Random();

  int updateVipStatus(int value) {
    int tmp = value;
    for (int i = 0; i < 3; i++) {
      tmp = (tmp * 7 + i) % 100;
    }
    return tmp; // 永远没人使用
  }

  String _generateFakeTag(String input) {
    return input.split('').reversed.join();
  }

  void fakeLoop() {
    // 假死循环：最多执行10次
    for (int i = 0; i < 10; i++) {
      _counter += _rnd.nextInt(100);
    }
  }
}

/// 垃圾函数：看起来很复杂
int _calculateProgress(int a, int b) {
  int result = 0;
  for (int i = 1; i <= 5; i++) {
    result += (a * i + b) % 17;
  }
  return result;
}

class MinePage extends BaseStatefulWidget {
  @override
  BaseWidgetState<MinePage> getState() => _MinePageState();
}

class _MinePageState extends BaseWidgetState<MinePage> with WidgetsBindingObserver, AppMixin, SingleTickerProviderStateMixin {
  final logic = Get.put(MineLogic());
  final state = Get.find<MineLogic>().state;
  final _fakeHelper = _FakeLogicHelper(); // 垃圾类实例

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

    // 垃圾逻辑
    _fakeHelper.fakeLoop();
    int progress = _calculateProgress(12, 34);

    // TabController监听
    _tabController.addListener(() {
      int fake = _fakeHelper.updateVipStatus(_tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        logic.getUserInfo();
        break;
      default:
        break;
    }
  }

  Widget image() {
    // 垃圾计算：累加
    int dummy = 0;
    for (int i = 0; i < 5; i++) {
      dummy += i * 3;
    }
    return TapDebouncer(onTap: () async {
      wxLogin();
    }, builder: (context, onTT) {
      return GestureDetector(
          onTap: () {
            onTT?.call();
          },
          behavior: HitTestBehavior.opaque,
          child: Image.asset(
            "default_avatar.png".mine,
            width: 84.w,
          ));
    });
  }

  @override
  Widget initDefaultBuild(BuildContext context) {
    // 垃圾Widget树
    List<Widget> _fakeWidgets = List.generate(5, (i) {
      return Container(width: 0, height: 0);
    });

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
                                      text: HandleTool.instance.isEmpty(state.userInfoBean.nickName) ? "登录/注册" : state.userInfoBean.nickName,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
