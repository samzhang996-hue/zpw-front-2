import 'dart:io';

import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/modules/main/model/zpw_user_info_bean.dart';
import 'package:zpw/modules/mine/zpw_mine_logic.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';
import 'package:zpw/utils/zpw_sp_utils.dart';

import 'zpw_setting_state.dart';

class ZpwSettingLogic extends ZpwBaseGetxController {
  final ZpwSettingState state = ZpwSettingState();
  final mineZpwLogic = Get.find<ZpwMineLogic>();

  // 兼容旧属性名
  ZpwMineLogic get mineLogic => mineZpwLogic;

  deleteUser() async {
    final result = await getAsync(ZpwApi.zpwDeleteUser, isShowProgress: true);
    UmengCommonSdk.onProfileSignOff();
    ZpwHandleTool.showAppToastText("注销成功");
    ZpwSpUtils.clear();
    await 0.5.delay();
    // ZpwSpUtils.setString("token", "");

    exit(-1);
    // if (result.isSuccess && result.hasData) {
    //   ZpwHandleTool.showAppToastText("注销成功");
    // }
  }

  void bindPhone() {
    if (mineZpwLogic.state.userInfoBean.userPhone?.isNotEmpty == true) {
      return;
    }
    ZpwLog.e("bindPhone");
  }

  void bindWx() {
    return;
    if (mineZpwLogic.state.userInfoBean.userPhone?.isNotEmpty == true) {
      return;
    }
    ZpwLog.e("bindWx");
  }

  void onExit() async {
    final result = await getAsync(ZpwApi.zpwLogout, isShowProgress: true);
    ZpwHandleTool.showAppToastText("退出成功");
    await 0.15.delay();
    ZpwSpUtils.setString("token", "");
    ZpwHandleTool.instance.token = "";
    final mineZpwLogic = Get.find<ZpwMineLogic>();
    mineZpwLogic.state.userInfoBean = ZpwUserInfoBean();
    ZpwHandleTool.instance.isMember = false;
    mineZpwLogic.update();
    Get.back();
    // if (result.isSuccess && result.hasData) {
    //   ZpwHandleTool.showAppToastText("注销成功");
    // }
  }
}
