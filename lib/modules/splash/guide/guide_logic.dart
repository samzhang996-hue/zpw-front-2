import 'package:get/get.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/splash/guide/view/custom_photo_dialog_utils.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/log_utils.dart';

import 'guide_state.dart';

class GuideLogic extends BaseGetxController {
  final GuideState state = GuideState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getFuncDetail();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    CustomPhotoDialogUtils.showCustomDialog(
        context: navigator!.context, onPressed: () {});
  }

  getFuncDetail() {
    get(Api.getFuncDetail, isShowProgress: true,
        success: (isSuccess, code, message, results) async {
      if (isSuccess == true && results.isNotEmpty) {
        Map data = results.first as Map;
        state.showImgGif = data["showImgGif"];
        state.funcName = data["tags"] ?? "";
        Log.d("fun---$data");
        update();
      }
    });
  }
}
