import 'package:get/get.dart';

import '../base/base_getx_controller.dart';
import '../model/config_by_key_model.dart';
import '../network/api/network_api.dart';

class ConfigByKeyController extends BaseGetxController {
  late final showPicture = false.obs;

  void getConfigByKey() {
    get<ConfigByKeyModel>(Api.getConfigByKey,
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            showPicture.value = results.first.configValue == "1";
          }
        },
        onModel: (m) => ConfigByKeyModel.fromJson(m));
  }
}
