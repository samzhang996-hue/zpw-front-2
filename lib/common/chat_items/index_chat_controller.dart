import 'package:get/get.dart';

import '../../model/smart_model.dart';
import '../../network/api/network_api.dart';
import '../../utils/handle_tool.dart';

class IndexChatController extends GetxController {
  RxList<SmartModel> data = RxList([]);

  Future<void> getData() async {
    // data.value = await utils.apis.getSmartModel(tags: tag == 'AI对话' ? '' : tag);

    HandleTool.instance.QDSGet<SmartModel>(Api.getSmartModel,
        isShowProgress: true,
        params: {
          "tags": '',
        },
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            data.value = results;
            update();
          }
        },
        onModel: (json) => SmartModel.fromJson(json));
  }
}
