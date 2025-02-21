import 'dart:io';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/filecache.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/my_plugin.dart';
import 'package:zpw/utils/sp_utils.dart';

import 'setting_state.dart';

class SettingLogic extends BaseGetxController {
  final SettingState state = SettingState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    version();
    _showCacheSize();
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

  void version() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.version;
    state.version.value = localVersion;
  }

  deleteUser() {
    get(Api.deleteUser, isShowProgress: true,
        success: (isSuccess, code, message, results) async {
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
}
