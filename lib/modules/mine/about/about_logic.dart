import 'dart:io';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/filecache.dart';
import '../../../utils/handle_tool.dart';
import '../../../utils/my_plugin.dart';
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

  void version() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.version;
    state.version.value = localVersion;
  }
}
