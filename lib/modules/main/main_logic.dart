// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/main/main_state.dart';
import 'package:zpw/utils/handle_tool.dart';

import '../../controller/config_by_key_controller.dart';
import '../vip/vip_view.dart';

class MainLogic extends BaseGetxController {
  final MainState state = MainState();
  final ConfigByKeyController configByKeyController = Get.find<ConfigByKeyController>();

  changeIndex(int index) {
    UmengCommonSdk.onEvent('MainLogic_click_event', {'index': '$index'});
    state.currentIndex.value = index;
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    HandleTool.instance.packagesGetForcePackage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!HandleTool.instance.isMember) {
        Get.to(() => VipPage());
      }
    });
  }

  // 刷新VIP状态，更新以及页面数据集状态
  updateVipStatus(bool isMember) {
    state.isMember.value = isMember;
    state.recreatePages();
    update();
  }
}
