import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/modules/mine/mine_logic.dart';

import '../../../network/api/network_api.dart';
import '../../../utils/filecache.dart';
import '../../../utils/handle_tool.dart';
import '../../../utils/my_plugin.dart';
import '../../../utils/sp_utils.dart';
import '../../main/model/user_info_bean.dart';
import 'about_state.dart';

class AboutLogic extends GetxController {
  final AboutState state = AboutState();
  late final isUpdate = false.obs;
  @override
  void onInit() {
    super.onInit();
    version();
    _showCacheSize();
    HandleTool.instance.packagesGetForcePackage(isSetting: true);
  }

  getChannel() async {
    String channelInfo = await getChannelInfo();
    state.channel.value = channelInfo;
  }

  void _showCacheSize() async {
    state.size.value = await loadCache();
  }

  /// 清理缓存
  void clearCache() async {
    Directory tempDir = await getTemporaryDirectory();
    //删除缓存目录
    if (Platform.isAndroid) {
      await delDir(tempDir);
    }

    if (Platform.isIOS) {
      await delDiriOS(tempDir);
    }

    await loadCache();
    _showCacheSize();
    HandleTool.showAppToastText('清除缓存成功');
  }

  void version() {
    state.version.value = HandleTool.instance.localVersion;
  }

  accountLogin(String name, String password) {
    Map<String, dynamic> dataMap = {
      "account": name,
      "password": password,
    };

    final MineLogic mineLogic = Get.find<MineLogic>();
    HandleTool.instance.SMWPost(Api.accountLogin, params: dataMap, isShowProgress: true, success: (isSuccess, code, message, results) async {
      if (isSuccess == true && results.isNotEmpty) {
        final map = results.first as Map;
        Navigator.pop(navigator!.context); // 关闭弹窗
        HandleTool.showAppToastText("切换成功");
        // mineLogic.getUserInfo();
        await SpUtils.setString("token", "${map["token"]}");
        HandleTool.instance.token = "${map["token"]}";
        mineLogic.getUserInfo();
        Get.back();
      }
    });
  }

  void onDoubleTap() {
    HandleTool.showAppToastText('当前渠道：${HandleTool.instance.channel}');
  }

  deleteUser() {
    HandleTool.instance.QDSGet(Api.deleteUser, isShowProgress: true, success: (isSuccess, code, message, results) async {
      UmengCommonSdk.onProfileSignOff();
      HandleTool.showAppToastText("注销成功");
      SpUtils.clear();
      await 0.5.delay();
      // SpUtils.setString("token", "");

      exit(-1);
      // if (isSuccess == true && results.isNotEmpty) {
      //   HandleTool.showAppToastText("注销成功");
      // }
    });
  }

  void onExit() {
    HandleTool.instance.QDSGet(Api.logout, isShowProgress: true, success: (isSuccess, code, message, results) async {
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
    });
  }
}
