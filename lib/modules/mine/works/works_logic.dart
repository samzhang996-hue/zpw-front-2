import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/face/face_make_page.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
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


  Future<void> photoRecord() async {
    Map<String, dynamic> dataMap = {
      "pageIndex": 0,
      "pageSize": 100,
      "worksType": state.index.value,
    };

    try {
      final response = await HttpClient().get(
        ApiConfig.photoRecord,
        queryParameters: dataMap,
        showLoading: false,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        if (dataList.isNotEmpty) {
          Map data = dataList.first as Map;
          state.records.value = data["records"];
          // Log.d("get----${data["records"]}");
          update();
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  Future<void> getFuncDetail(int funcId, int id) async {
    try {
      final response = await HttpClient().get(
        "${ApiConfig.getFuncDetail}?id=$funcId",
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        if (dataList.isNotEmpty) {
          Map data = dataList.first as Map;
          String showImgGif = data["showImgGif"];
          String funcName = data["tags"] ?? "";
          // int funcId = data["funcId"] ?? "";
          String videoUrl = data["videoUrl"] ?? "";
          int apiType = data["apiType"] ?? -1;

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
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await HttpClient().post(
        "${ApiConfig.delete}/$id",
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        if (dataList.isNotEmpty) {
          // HandleTool.showAppToastText("删除成功");
          // Get.back(result: "123");
          photoRecord();
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }
}
