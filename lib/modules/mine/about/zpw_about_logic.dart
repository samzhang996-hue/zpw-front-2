import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zpw/modules/mine/zpw_mine_logic.dart';

import '../../../network/api/zpw_network_api.dart';
import '../../../network/zpw_network_util.dart';
import '../../../utils/zpw_filecache.dart';
import '../../../utils/zpw_handle_tool.dart';
import '../../../utils/zpw_my_plugin.dart';
import '../../../utils/zpw_sp_utils.dart';
import 'about_state.dart';

class AboutLogic extends GetxController {
  final AboutState state = AboutState();
  late final isUpdate = false.obs;
  @override
  void onInit() {
    super.onInit();
    version();
    _showCacheSize();
    ZpwHandleTool.instance.packagesGetForcePackage(isSetting: true);
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
    ZpwHandleTool.showAppToastText('清除缓存成功');
  }

  void version() {
    state.version.value = ZpwHandleTool.instance.localVersion;
  }

  accountLogin(String name, String password) async {
    Map<String, dynamic> dataMap = {
      "account": name,
      "password": password,
    };

    final MineLogic mineLogic = Get.find<MineLogic>();
    final result = await ZpwDioUtils.instance.postAsync<Map<String, dynamic>>(
      ZpwApi.zpwAccountLogin,
      params: dataMap,
      isShowProgress: true,
    );

    if (result.isSuccess && result.hasData) {
      final map = result.first!;
      Navigator.pop(navigator!.context); // 关闭弹窗
      ZpwHandleTool.showAppToastText("切换成功");
      await ZpwSpUtils.setString("token", "${map["token"]}");
      ZpwHandleTool.instance.token = "${map["token"]}";
      mineLogic.getUserInfo();
      Get.back();
    }
  }

  void onDoubleTap() {
    ZpwHandleTool.showAppToastText('当前渠道：${ZpwHandleTool.instance.channel}');
  }
}
