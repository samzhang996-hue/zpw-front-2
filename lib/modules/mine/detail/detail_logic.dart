import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/face/face_make_page.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
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
      update();
    }
  }

  Future<void> delete() async {
    try {
      final response = await HttpClient().post(
        "${ApiConfig.delete}/${state.id.value}",
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        if (dataList.isNotEmpty) {
          HandleTool.showAppToastText("删除成功");
          Get.back(result: "123");
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  Future<void> getFuncDetail(int id) async {
    try {
      final response = await HttpClient().get(
        "${ApiConfig.getFuncDetail}?id=$id",
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        if (dataList.isNotEmpty) {
          Map data = dataList.first as Map;
          String showImgGif = data["showImgGif"];
          String funcName = data["tags"] ?? "";
          String videoUrl = data["videoUrl"] ?? "";
          int apiType = data["apiType"] ?? -1;

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
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }
}
