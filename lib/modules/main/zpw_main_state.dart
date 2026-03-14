import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zpw/modules/face/zpw_face_view.dart';
import 'package:zpw/modules/gameplay/zpw_gameplay_view.dart';
import 'package:zpw/modules/mine/zpw_mine_view.dart';
import 'package:zpw/modules/specially/zpw_specially_view.dart';
import 'package:zpw/modules/wf/zpw_wf_view.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';

class ZpwMainState {
  late RxInt index;
  late RxInt currentIndex;
  late List<Widget> pages;
  late PageController pageController;
  late RxString pageType;
  late RxMap<String, dynamic> configData;
  late RxBool isMember;

  ZpwMainState() {
    index = 0.obs;
    currentIndex = 0.obs;
    isMember = ZpwHandleTool().isMember.obs;

    pages = [
      // HomePage(),
      ZpwGameplayPage(),
      ZpwFacePage(),
      ZpwSpeciallyPage(),
      ZpwWfPage(),
      ZpwMinePage(),
    ].obs;
    // 用户协议数据
    configData = <String, dynamic>{}.obs;
    pageController = PageController(initialPage: 0);
  }

  // 重新创建一级页面
  recreatePages() {
    // pages = [
    //   const HomePage(),
    //   const CleanPage(),
    //   ZpwMinePage(),
    // ];
  }
}
