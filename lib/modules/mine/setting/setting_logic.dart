import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/main/model/user_info_bean.dart';
import 'package:zpw/modules/mine/mine_logic.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:zpw/utils/sp_utils.dart';

import 'setting_state.dart';

class SettingLogic extends BaseGetxController {
  final SettingState state = SettingState();
  final mineLogic = Get.find<MineLogic>();

  Future<void> deleteUser() async {
    try {
      final response = await HttpClient().get(
        ApiConfig.deleteUser,
        showLoading: true,
      );

      UmengCommonSdk.onProfileSignOff();
      HandleTool.showAppToastText("注销成功");
      SpUtils.clear();
      await 0.5.delay();
      // SpUtils.setString("token", "");

      exit(-1);
      // if (isSuccess == true && results.isNotEmpty) {
      //   HandleTool.showAppToastText("注销成功");
      // }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  void bindPhone() {
    if (mineLogic.state.userInfoBean.userPhone?.isNotEmpty == true) {
      return;
    }
  }

  void bindWx() {
    return;
    if (mineLogic.state.userInfoBean.userPhone?.isNotEmpty == true) {
      return;
    }
  }

  Future<void> onExit() async {
    try {
      final response = await HttpClient().get(
        ApiConfig.logout,
        showLoading: true,
      );

      HandleTool.showAppToastText("退出成功");
      await 0.15.delay();
      SpUtils.setString("token", "");
      HandleTool.instance.token = "";
      final mineLogic = Get.find<MineLogic>();
      mineLogic.state.userInfoBean = UserInfoBean();
      HandleTool.instance.isMember = false;
      mineLogic.update();
      Get.back();
      // if (isSuccess == true && results.isNotEmpty) {
      //   HandleTool.showAppToastText("注销成功");
      // }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }
}
