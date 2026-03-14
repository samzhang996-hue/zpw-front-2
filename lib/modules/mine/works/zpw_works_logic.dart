import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/modules/face/zpw_face_make_page.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import 'zpw_works_state.dart';

class ZpwWorksZpwLogic extends ZpwBaseGetxController {
  final ZpwWorksState state = ZpwWorksState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    photoRecord();
  }

  stateIndex(int index) {
    state.index.value = index;
    update();
  }


  photoRecord() async {
    Map<String, dynamic> dataMap = {
      "pageIndex": 0,
      "pageSize": 100,
      "worksType": state.index.value,
    };
    ZpwLog.d("map-----------$dataMap");
    final result = await getAsync(ZpwApi.zpwPhotoRecord, isShowProgress: false, params: dataMap);
    if (result.isSuccess && result.hasData) {
      Map data = result.first as Map;
      state.records.value = data["records"];
      // ZpwLog.d("get----${data["records"]}");
      update();
    }
  }

  getFuncDetail(int funcId, int id) async {
    final result = await getAsync("${ZpwApi.zpwGetFuncDetail}?id=$funcId", isShowProgress: true);
    if (result.isSuccess && result.hasData) {
      Map data = result.first as Map;
      String showImgGif = data["showImgGif"];
      String funcName = data["tags"] ?? "";
      // int funcId = data["funcId"] ?? "";
      String videoUrl = data["videoUrl"] ?? "";
      int apiType = data["apiType"] ?? -1;

      ZpwLog.d("fun---$data");
      Get.to(
        () => ZpwFaceMakePage(
          title: funcName,
          funcId: funcId,
          imageUrl: showImgGif,
          videoUrl: videoUrl,
          apiType: apiType,
        ),
      );
      delete(id);
      update();
    }
  }

  delete(int id) async {
    final result = await postAsync("${ZpwApi.zpwDelete}/$id", isShowProgress: true);
    if (result.isSuccess && result.hasData) {
      // ZpwHandleTool.showAppToastText("删除成功");
      // Get.back(result: "123");
      photoRecord();
    }
  }
}
