import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/modules/gameplay/zpw_gameplay_logic.dart';
import 'package:zpw/modules/main/model/zpw_user_info_bean.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import '../../utils/zpw_sp_utils.dart';
import 'mine_state.dart';

class MineLogic extends ZpwBaseGetxController {
  final MineState state = MineState();

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  getUserInfo({bool isShowProgress = false}) async {
    final isEmpty = ZpwHandleTool.instance.isEmpty(await ZpwSpUtils.getString("token"));
    if (isEmpty) {
      state.userInfoBean = UserInfoBean();
      ZpwHandleTool.instance.isMember = false;
      update();
      return;
    }
    final logic = Get.put(GameplayLogic());
    final result = await postAsync<UserInfoBean>(ZpwApi.zpwSsoGetUserInfo,
        isShowProgress: isShowProgress,
        onModel: (m) => UserInfoBean.fromJson(m));
    if (result.isSuccess && result.hasData) {
      ZpwLog.d("userInfoBean----${result.first}");
      state.userInfoBean = result.first!;
      ZpwHandleTool.instance.isMember = state.userInfoBean.vipFlag == 1;
      logic.stateShowVip(ZpwHandleTool.instance.isMember);
      update();
    }
  }
}
