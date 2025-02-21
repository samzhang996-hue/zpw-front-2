import 'package:get/get.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/gameplay/gameplay_logic.dart';
import 'package:zpw/modules/main/model/user_info_bean.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

import 'mine_state.dart';

class MineLogic extends BaseGetxController {
  final MineState state = MineState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserInfo();
  }

  getUserInfo() {
    final logic = Get.put(GameplayLogic());
    Post<UserInfoBean>(Api.sso_getUserInfo,
        isShowProgress: false,
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
}
