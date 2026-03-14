import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/modules/face/face_make_page.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import 'works_state.dart';

class WorksZpwLogic extends ZpwBaseGetxController {
  final WorksState state = WorksState();

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


  photoRecord() {
    Map<String, dynamic> dataMap = {
      "pageIndex": 0,
      "pageSize": 100,
      "worksType": state.index.value,
    };
    ZpwLog.d("map-----------$dataMap");
    get(ZpwApi.zpwPhotoRecord, isShowProgress: false, params: dataMap, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        Map data = results.first as Map;
        state.records.value = data["records"];
        // ZpwLog.d("get----${data["records"]}");
        update();
      }
    });
  }

  getFuncDetail(int funcId, int id) {
    get("${ZpwApi.zpwGetFuncDetail}?id=$funcId", isShowProgress: true, success: (isSuccess, code, message, results) async {
      if (isSuccess == true && results.isNotEmpty) {
        Map data = results.first as Map;
        String showImgGif = data["showImgGif"];
        String funcName = data["tags"] ?? "";
        // int funcId = data["funcId"] ?? "";
        String videoUrl = data["videoUrl"] ?? "";
        int apiType = data["apiType"] ?? -1;

        ZpwLog.d("fun---$data");
        Get.to(
          () => FaceMakePage(
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
    });
  }

  delete(int id) {
    Post("${ZpwApi.zpwDelete}/$id", isShowProgress: true, success: (isSuccess, code, message, results) async {
      if (isSuccess == true && results.isNotEmpty) {
        // ZpwHandleTool.showAppToastText("删除成功");
        // Get.back(result: "123");
        photoRecord();
      }
    });
  }
}
