import 'package:get/get.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/face/face_make_page.dart';
import 'package:zpw/modules/gameplay/gameplay_logic.dart';
import 'package:zpw/modules/main/model/user_info_bean.dart';
import 'package:zpw/network/api/network_api.dart';
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

  getUserInfo({bool isShowProgress = false}) async {
    final isEmpty = HandleTool.instance.isEmpty(await SpUtils.getString("token"));
    if (isEmpty) {
      state.userInfoBean = UserInfoBean();
      HandleTool.instance.isMember = false;
      update();
      return;
    }
    final logic = Get.put(GameplayLogic());
    Post<UserInfoBean>(Api.sso_getUserInfo,
        isShowProgress: isShowProgress,
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            Log.d("userInfoBean----${results.first}");
            state.userInfoBean = results.first;
            HandleTool.instance.isMember = state.userInfoBean.vipFlag == 1;
            logic.stateShowVip(HandleTool.instance.isMember);
            update();
          }
        },
        onModel: (m) => UserInfoBean.fromJson(m));
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
