import 'package:get/get.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import 'wst_state.dart';

class WstLogic extends GetxController {
  final WstState state = WstState();

  @override
  void onInit() {
    super.onInit();
    var map = Get.arguments;
    if (map != null) {
      state.showImgGif.value = map["showImgGif"] ?? "";
      state.funcValue.value = map["funcValue"] ?? "";
      state.funcId.value = map["funcId"] ?? 0;
      ZpwLog.d("funcId---${state.funcId.value}");
      update();
    }
  }
}
