import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/face/face_make_page.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:get/get.dart';
import 'works_state.dart';

class WorksLogic extends BaseGetxController {
  final WorksState state = WorksState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    photoRecord(1);
  }

  photoRecord(int type) {
    Map<String, dynamic> dataMap = {
      "pageIndex": 1,
      "pageSize": 100,
      "worksType": type,
    };
    get(Api.photoRecord, isShowProgress: true, params: dataMap, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        Map data = results.first as Map;
        state.records =data["records"];
        Log.d("get----${state.records}");
        update();
      }
    });
  }
  getFuncDetail(int funcId,int id) {
    get("${Api.getFuncDetail}?id=$id", isShowProgress: true,
        success: (isSuccess, code, message, results) async {
          if (isSuccess == true && results.isNotEmpty) {
            Map data = results.first as Map;
            String showImgGif = data["showImgGif"];
            String funcName = data["tags"] ?? "";
            // int funcId = data["funcId"] ?? "";
            String videoUrl = data["videoUrl"] ?? "";
            Log.d("fun---$data");
            Get.to(
                  () => FaceMakePage(
                title: funcName,
                funcId: funcId,
                imageUrl: showImgGif,
                videoUrl: videoUrl,
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
        photoRecord(state.index);
      }
    });
  }
}
