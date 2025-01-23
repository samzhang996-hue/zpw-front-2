import 'package:get/get.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/model/list_photo_group_bean.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

import 'wf_state.dart';

class WfLogic extends BaseGetxController {
  final WfState state = WfState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }

  void getData() {
    Log.d("list----");
    get<ListPhotoGroupBean>(Api.listPhotoGroup,
        isShowProgress: true,
        params: {
          "groupType": 2,
        },
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            state.listPhotoGroupBean = results;
            Log.d("list----${state.listPhotoGroupBean[0].toJson()}");
            update();
          }
        },
        onModel: (json) => ListPhotoGroupBean.fromJson(json));
  }
}
