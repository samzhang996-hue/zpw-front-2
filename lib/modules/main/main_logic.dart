// ignore_for_file: unnecessary_overrides

import 'package:get/get.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/main/main_state.dart';
import 'package:zpw/modules/vip/vip_view.dart';
import 'package:zpw/utils/handle_tool.dart';

class MainLogic extends BaseGetxController {
  final MainState state = MainState();

  changeIndex(int index) {
    state.currentIndex.value = index;
    update();
  }

  @override
  void onInit() {
    super.onInit();

    // HandleTool.instance.packagesGetForcePackage();
    Future.delayed((const Duration(microseconds: 200)), () {
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
