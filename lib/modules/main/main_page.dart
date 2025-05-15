import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/style.dart';
import 'package:zpw/modules/home/home_view.dart';
import 'package:zpw/modules/main/main_logic.dart';

import '../face/face_view.dart';
import '../mine/mine_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final logic = Get.put(MainLogic());

  final state = Get.find<MainLogic>().state;

  @override
  void dispose() {
    Get.delete<MainLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(builder: (logic) {
      return Scaffold(
        backgroundColor: ColorPlate.themeBgColor,
        body: Obx(() => IndexedStack(
              index: state.currentIndex.value,
              children: [
                const HomePage(),
                // const GameplayPage(),
                if (logic.configByKeyController.showPicture.isTrue) const FacePage(),
                // SpeciallyPage(),
                // WfPage(),
                MinePage(),
              ],
            )),
        bottomNavigationBar: GetBuilder<MainLogic>(
          builder: (logic) {
            return Obx(
              () => BottomNavigationBar(
                // 当前菜单下标
                currentIndex: state.currentIndex.value,
                // 点击事件,获取当前点击的标签下标
                onTap: (int idx) {
                  // if (idx == 1) return;
                  logic.changeIndex(idx);
                },
                iconSize: 36.0,
                selectedItemColor: ColorPlate.tabbarThemeColor,
                unselectedItemColor: ColorPlate.tabbarTextColorNormal,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedFontSize: 12.sp,
                unselectedFontSize: 12.sp,
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'un_home.png'.tabbar,
                      width: 36,
                      height: 36,
                    ),
                    activeIcon: Image.asset(
                      'home.png'.tabbar,
                      width: 36,
                      height: 36,
                    ),
                    label: "首页",
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Image.asset(
                  //     'un_gameplay.png'.tabbar,
                  //     width: 36,
                  //     height: 36,
                  //   ),
                  //   activeIcon: Image.asset(
                  //     'gameplay.png'.tabbar,
                  //     width: 36,
                  //     height: 36,
                  //   ),
                  //   label: "视频",
                  // ),
                  if (logic.configByKeyController.showPicture.isTrue)
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        'un_pic.png'.tabbar,
                        width: 36,
                        height: 36,
                      ),
                      activeIcon: Image.asset(
                        'pic.png'.tabbar,
                        width: 36,
                        height: 36,
                      ),
                      label: "图片",
                    ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'un_mine.png'.tabbar,
                      width: 36,
                      height: 36,
                    ),
                    activeIcon: Image.asset(
                      'mine.png'.tabbar,
                      width: 36,
                      height: 36,
                    ),
                    label: "我的",
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
