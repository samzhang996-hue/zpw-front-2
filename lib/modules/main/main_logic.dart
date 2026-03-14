// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/modules/main/main_state.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';

import '../vip/vip_view.dart';

class MainLogic extends ZpwBaseGetxController {
  final MainState state = MainState();

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
    ZpwHandleTool.instance.packagesGetForcePackage();
    if (!ZpwHandleTool.instance.isMember) {
      Get.to(() => VipPage());
    }
  }

  // 刷新VIP状态，更新以及页面数据集状态
  updateVipStatus(bool isMember) {
    state.isMember.value = isMember;
    state.recreatePages();
    update();
  }
}
