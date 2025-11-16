import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/face/face_make_page.dart';
import 'package:zpw/modules/gameplay/gameplay_logic.dart';
import 'package:zpw/modules/main/model/user_info_bean.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

import '../../utils/sp_utils.dart';
import 'mine_state.dart';

class MineLogic extends BaseGetxController {
  final MineState state = MineState();

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
    photoRecord();
  }

  Future<void> getUserInfo({bool isShowProgress = false}) async {
    final isEmpty = HandleTool.instance.isEmpty(await SpUtils.getString("token"));
    if (isEmpty) {
      state.userInfoBean = UserInfoBean();
      HandleTool.instance.isMember = false;
      update();
      return;
    }
    final logic = Get.put(GameplayLogic());

    try {
      final response = await HttpClient().post(
        ApiConfig.sso_getUserInfo,
        showLoading: isShowProgress,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        final results = dataList
            .map((e) => UserInfoBean.fromJson(e as Map<String, dynamic>))
            .toList();
        if (results.isNotEmpty) {
          state.userInfoBean = results.first;
          HandleTool.instance.isMember = state.userInfoBean.vipFlag == 1;
          logic.stateShowVip(HandleTool.instance.isMember);
          update();
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
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
