import 'dart:io';

import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/main/model/user_info_bean.dart';
import 'package:zpw/modules/mine/mine_logic.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:zpw/utils/sp_utils.dart';

import 'setting_state.dart';

class SettingLogic extends BaseGetxController {
  final SettingState state = SettingState();
  final mineLogic = Get.find<MineLogic>();

  deleteUser() {
    get(Api.deleteUser, isShowProgress: true, success: (isSuccess, code, message, results) async {
      UmengCommonSdk.onProfileSignOff();
      HandleTool.showAppToastText("注销成功");
      await 0.5.delay();
      SpUtils.setString("token", "");
      exit(-1);
      // if (isSuccess == true && results.isNotEmpty) {
      //   HandleTool.showAppToastText("注销成功");
      // }
    });
  }

  void bindPhone() {
    if (mineLogic.state.userInfoBean.userPhone?.isNotEmpty == true) {
      return;
    }
    Log.e("bindPhone");
  }

  void bindWx() {
    return;
    if (mineLogic.state.userInfoBean.userPhone?.isNotEmpty == true) {
      return;
    }
    Log.e("bindWx");
  }

  void onExit() {
    get(Api.logout, isShowProgress: true, success: (isSuccess, code, message, results) async {
      HandleTool.showAppToastText("退出成功");
      await 0.15.delay();
      SpUtils.setString("token", "");
      final mineLogic = Get.find<MineLogic>();
      mineLogic.state.userInfoBean = UserInfoBean();
      HandleTool.instance.isMember = false;
      mineLogic.update();
      Get.back();
      // if (isSuccess == true && results.isNotEmpty) {
      //   HandleTool.showAppToastText("注销成功");
      // }
    });
  }
}
