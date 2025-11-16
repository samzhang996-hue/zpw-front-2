import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../base/base_getx_controller.dart';
import '../model/config_by_key_model.dart';
import '../network/api_config.dart';
import '../network/http_client.dart';

class ConfigByKeyController extends BaseGetxController {
  late final showPicture = false.obs;

  Future<void> getConfigByKey() async {
    try {
      final response = await HttpClient().get(
        ApiConfig.getConfigByKey,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        final results = dataList
            .map((e) => ConfigByKeyModel.fromJson(e as Map<String, dynamic>))
            .toList();
        if (results.isNotEmpty) {
          showPicture.value = results.first.configValue == "1";
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }
}
