import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../model/smart_model.dart';
import '../../network/api_config.dart';
import '../../network/http_client.dart';

class IndexChatController extends GetxController {
  RxList<SmartModel> data = RxList([]);

  Future<void> getData() async {
    // data.value = await utils.apis.getSmartModel(tags: tag == 'AI对话' ? '' : tag);

    try {
      final response = await HttpClient().get(
        ApiConfig.getSmartModel,
        queryParameters: {
          "tags": '',
        },
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        final results = dataList
            .map((e) => SmartModel.fromJson(e as Map<String, dynamic>))
            .toList();
        if (results.isNotEmpty) {
          data.value = results;
          update();
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }
}
