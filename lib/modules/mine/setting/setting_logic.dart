import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zpw/utils/log_utils.dart';
import 'setting_state.dart';

class SettingLogic extends GetxController {
  final SettingState state = SettingState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    version();
  }

  void version() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.version;
    String localBuildnumber = packageInfo.buildNumber;
    Log.d("msg----$localVersion-----$localBuildnumber");
  }
}
