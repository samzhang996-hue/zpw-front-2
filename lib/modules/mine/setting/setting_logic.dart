import 'dart:io';

import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/modules/main/model/user_info_bean.dart';
import 'package:zpw/modules/mine/mine_logic.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';
import 'package:zpw/utils/zpw_sp_utils.dart';

import 'setting_state.dart';

class SettingLogic extends ZpwBaseGetxController {
  final SettingState state = SettingState();
  final mineZpwLogic = Get.find<MineLogic>();

  // 兼容旧属性名
  MineLogic get mineLogic => mineZpwLogic;

  deleteUser() {
    get(ZpwApi.zpwDeleteUser, isShowProgress: true, success: (isSuccess, code, message, results) async {
      UmengCommonSdk.onProfileSignOff();
      ZpwHandleTool.showAppToastText("注销成功");
      ZpwSpUtils.clear();
      await 0.5.delay();
      // ZpwSpUtils.setString("token", "");

      exit(-1);
      // if (isSuccess == true && results.isNotEmpty) {
      //   ZpwHandleTool.showAppToastText("注销成功");
      // }
    });
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

  void onExit() {
    get(ZpwApi.zpwLogout, isShowProgress: true, success: (isSuccess, code, message, results) async {
      ZpwHandleTool.showAppToastText("退出成功");
      await 0.15.delay();
      ZpwSpUtils.setString("token", "");
      ZpwHandleTool.instance.token = "";
      final mineZpwLogic = Get.find<MineLogic>();
      mineZpwLogic.state.userInfoBean = UserInfoBean();
      ZpwHandleTool.instance.isMember = false;
      mineZpwLogic.update();
      Get.back();
      // if (isSuccess == true && results.isNotEmpty) {
      //   ZpwHandleTool.showAppToastText("注销成功");
      // }
    });
  }
}
