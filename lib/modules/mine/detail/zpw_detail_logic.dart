import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/modules/face/zpw_face_make_page.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import 'detail_state.dart';

class DetailZpwLogic extends ZpwBaseGetxController {
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
      ZpwLog.d("param---${state.returnUrl.value}---${state.apiType.value}");
      update();
    }
    ZpwLog.d("param---${state.returnUrl.value}---${state.worksType.value}");
  }

  delete() async {
    final result = await postAsync("${ZpwApi.zpwDelete}/${state.id.value}", isShowProgress: true);
    if (result.isSuccess && result.hasData) {
      ZpwHandleTool.showAppToastText("删除成功");
      Get.back(result: "123");
    }
  }

  getFuncDetail(int id) async {
    final result = await getAsync("${ZpwApi.zpwGetFuncDetail}?id=$id", isShowProgress: true);
    if (result.isSuccess && result.hasData) {
      Map data = result.first as Map;
      String showImgGif = data["showImgGif"];
      String funcName = data["tags"] ?? "";
      String videoUrl = data["videoUrl"] ?? "";
      int apiType = data["apiType"] ?? -1;

      ZpwLog.d("fun---$data");
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
  }
}
