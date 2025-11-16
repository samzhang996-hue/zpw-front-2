import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/modules/mine/mine_logic.dart';

import '../../../network/api_config.dart';
import '../../../network/http_client.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  Future<void> accountLogin(String name, String password) async {
    Map<String, dynamic> dataMap = {
      "account": name,
      "password": password,
    };

    final MineLogic mineLogic = Get.find<MineLogic>();

    try {
      final response = await HttpClient().post(
        ApiConfig.accountLogin,
        data: dataMap,
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final Map data = response.data as Map;
        Navigator.pop(navigator!.context); // 关闭弹窗
        HandleTool.showAppToastText("切换成功");
        // mineLogic.getUserInfo();
        await SpUtils.setString("token", "${data["token"]}");
        HandleTool.instance.token = "${data["token"]}";
        mineLogic.getUserInfo();
        Get.back();
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  void onDoubleTap() {
    HandleTool.showAppToastText('当前渠道：${HandleTool.instance.channel}');
  }

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
