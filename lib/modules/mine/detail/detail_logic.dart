import 'package:get/get.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/face/face_make_page.dart';
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
      state.funcId.value = map["funcId"] ?? 0;
      state.returnUrl.value = map["returnUrl"] ?? "";
      state.tags.value = map["tags"] ?? "";
      state.apiType.value = map["apiType"] ?? -1;
      Log.d("param---${state.returnUrl.value}---${state.apiType.value}");
      update();
    }
    Log.d("param---${state.returnUrl.value}---${state.worksType.value}");
  }

  delete() {
    Post("${Api.delete}/${state.id.value}", isShowProgress: true,
        success: (isSuccess, code, message, results) async {
      if (isSuccess == true && results.isNotEmpty) {
        HandleTool.showAppToastText("删除成功");
        Get.back(result: "123");
      }
    });
  }

  getFuncDetail(int id) {
    get("${Api.getFuncDetail}?id=$id", isShowProgress: true,
        success: (isSuccess, code, message, results) async {
      if (isSuccess == true && results.isNotEmpty) {
        Map data = results.first as Map;
        String showImgGif = data["showImgGif"];
        String funcName = data["tags"] ?? "";
        String videoUrl = data["videoUrl"] ?? "";
        int apiType = data["apiType"] ?? -1;

        Log.d("fun---$data");
        Get.to(
          () => FaceMakePage(
            title: funcName,
            funcId: id,
            imageUrl: showImgGif,
            videoUrl: videoUrl,
            apiType: apiType,
          ),
        );
        update();
      }
    });
  }
}
