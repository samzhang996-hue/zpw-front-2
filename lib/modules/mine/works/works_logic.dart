import 'package:get/get.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/face/face_make_page.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/log_utils.dart';

import 'works_state.dart';

class WorksLogic extends BaseGetxController {
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
    Log.d("map-----------$dataMap");
    get(Api.photoRecord, isShowProgress: false, params: dataMap, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        Map data = results.first as Map;
        state.records.value = data["records"];
        // Log.d("get----${data["records"]}");
        update();
      }
    });
  }

  getFuncDetail(int funcId, int id) {
    get("${Api.getFuncDetail}?id=$funcId", isShowProgress: true, success: (isSuccess, code, message, results) async {
      if (isSuccess == true && results.isNotEmpty) {
        Map data = results.first as Map;
        String showImgGif = data["showImgGif"];
        String funcName = data["tags"] ?? "";
        // int funcId = data["funcId"] ?? "";
        String videoUrl = data["videoUrl"] ?? "";
        int apiType = data["apiType"] ?? -1;

        Log.d("fun---$data");
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
    Post("${Api.delete}/$id", isShowProgress: true, success: (isSuccess, code, message, results) async {
      if (isSuccess == true && results.isNotEmpty) {
        // HandleTool.showAppToastText("删除成功");
        // Get.back(result: "123");
        photoRecord();
      }
    });
  }
}
