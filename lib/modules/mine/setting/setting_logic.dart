import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/base/base_getx_controller.dart';
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
      SpUtils.clear();
      exit(-1);
      // if (isSuccess == true && results.isNotEmpty) {
      //   HandleTool.showAppToastText("注销成功");
      // }
    });
  }

  void onExit() {
    Log.e("msg");
  }

  accountLogin(String name, String password) {
    Map<String, dynamic> dataMap = {
      "account": name,
      "password": password,
    };
    final MineLogic mineLogic = Get.find<MineLogic>();
    Post(Api.accountLogin, params: dataMap, isShowProgress: true, success: (isSuccess, code, message, results) async {
      if (isSuccess == true && results.isNotEmpty) {
        Navigator.pop(navigator!.context); // 关闭弹窗
        HandleTool.showAppToastText("登录成功");
        mineLogic.getUserInfo();
      }
    });
  }
}
