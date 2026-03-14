import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/common/zpw_constant.dart';
import 'package:zpw/common/zpw_style.dart';
import 'package:zpw/modules/main/zpw_main_logic.dart';

class ZpwMainPage extends StatefulWidget {
  const ZpwMainPage({super.key});

  @override
  State<ZpwMainPage> createState() => _ZpwMainPageState();
}

class _ZpwMainPageState extends State<ZpwMainPage> {
  final logic = Get.put(ZpwMainLogic());

  final state = Get.find<ZpwMainLogic>().state;

  @override
  void dispose() {
    Get.delete<ZpwMainLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ZpwMainLogic>(builder: (logic) {
      return Scaffold(
          backgroundColor: ZpwColorPlate.zpwThemeBgColor,
          body: IndexedStack(
            index: state.currentIndex.value,
            children: state.pages,
          ),
          bottomNavigationBar: GetBuilder<ZpwMainLogic>(
            builder: (logic) {
              return BottomNavigationBar(
                // 当前菜单下标
                currentIndex: state.currentIndex.value,
                // 点击事件,获取当前点击的标签下标
                onTap: (int idx) {
                  // if (idx == 1) return;
                  logic.changeIndex(idx);
                },
                iconSize: 36.0,
                selectedItemColor: ZpwColorPlate.zpwTabbarThemeColor,
                unselectedItemColor: ZpwColorPlate.zpwTabbarTextColorNormal,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedFontSize: 12.sp,
                unselectedFontSize: 12.sp,
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'zpw_un_home.png'.tabbar,
                      width: 36,
                      height: 36,
                    ),
                    activeIcon: Image.asset(
                      'zpw_home.png'.tabbar,
                      width: 36,
                      height: 36,
                    ),
                    label: "视频",
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'zpw_un_pic.png'.tabbar,
                      width: 36,
                      height: 36,
                    ),
                    activeIcon: Image.asset(
                      'zpw_pic.png'.tabbar,
                      width: 36,
                      height: 36,
                    ),
                    label: "图片",
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'zpw_un_tx.png'.tabbar,
                      width: 36,
                      height: 36,
                    ),
                    activeIcon: Image.asset(
                      'zpw_tx.png'.tabbar,
                      width: 36,
                      height: 36,
                    ),
                    label: "特效",
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'zpw_un_wf.png'.tabbar,
                      width: 36,
                      height: 36,
                    ),
                    activeIcon: Image.asset(
                      'zpw_wf.png'.tabbar,
                      width: 36,
                      height: 36,
                    ),
                    label: "玩法",
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'zpw_un_mine.png'.tabbar,
                      width: 36,
                      height: 36,
                    ),
                    activeIcon: Image.asset(
                      'zpw_mine.png'.tabbar,
                      width: 36,
                      height: 36,
                    ),
                    label: "我的",
                  ),
                ],
              );
            },
          ));
    });
  }
}
