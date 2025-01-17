import 'package:package_info_plus/package_info_plus.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/log_utils.dart';
import 'setting_state.dart';

class SettingLogic extends BaseGetxController {
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
    state.version.value=localVersion;
  }
  deleteUser() {
    Get(Api.deleteUser, isShowProgress: true, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {

      }
    });
  }
}
