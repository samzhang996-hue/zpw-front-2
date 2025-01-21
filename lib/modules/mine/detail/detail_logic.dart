import 'package:get/get.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

import 'detail_state.dart';

class DetailLogic extends BaseGetxController {
  final DetailState state = DetailState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var map = Get.arguments;
    if (map != null) {
      state.worksType.value = map["worksType"] ?? 0;
      state.id.value = map["id"] ?? 0;
      state.returnUrl.value = map["returnUrl"] ?? "";
      state.tags.value = map["tags"] ?? "";
      Log.d("param---${state.returnUrl.value}---${state.worksType.value}");
      update();
    }
    Log.d("param---${state.returnUrl.value}---${state.worksType.value}");
  }

  delete() {
    Post("${Api.delete}/${state.id.value}", isShowProgress: true, success: (isSuccess, code, message, results) async {
      if (isSuccess == true && results.isNotEmpty) {
        HandleTool.showAppToastText("删除成功");
        Get.back();
      }
    });
  }
}
