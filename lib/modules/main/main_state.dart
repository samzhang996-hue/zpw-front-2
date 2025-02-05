import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zpw/modules/face/face_view.dart';
import 'package:zpw/modules/gameplay/gameplay_view.dart';
import 'package:zpw/modules/mine/mine_view.dart';
import 'package:zpw/modules/specially/specially_view.dart';
import 'package:zpw/utils/handle_tool.dart';

class MainState {
  late RxInt index;
  late RxInt currentIndex;
  late List<Widget> pages;
  late PageController pageController;
  late RxString pageType;
  late RxMap<String, dynamic> configData;
  late RxBool isMember;

  MainState() {
    index = 0.obs;
    currentIndex = 0.obs;
    isMember = HandleTool().isMember.obs;

    pages = [
      // HomePage(),
      GameplayPage(),
      FacePage(),
      SpeciallyPage(),

      MinePage(),
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
    //   MinePage(),
    // ];
  }
}
