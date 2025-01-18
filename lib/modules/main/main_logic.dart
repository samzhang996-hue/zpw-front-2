// ignore_for_file: unnecessary_overrides

import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/main/main_state.dart';
import 'package:zpw/modules/main/model/user_info_bean.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

class MainLogic extends BaseGetxController {
  final MainState state = MainState();

  changeIndex(int index) {
    state.currentIndex.value = index;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    HandleTool.instance.packagesGetForcePackage();
    getUserInfo();
  }

  getUserInfo() {
    get<UserInfoBean>(Api.sso_getUserInfo,
        isShowProgress: true,
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            Log.d("userInfoBean----${results.first}");
            UserInfoBean userInfoBean = results.first;
            HandleTool.instance.isMember = userInfoBean.isMember ?? false;
          }
        },
        onModel: (m) => UserInfoBean.fromJson(m));
  }

  // 刷新VIP状态，更新以及页面数据集状态
  updateVipStatus(bool isMember) {
    state.isMember.value = isMember;
    state.recreatePages();
    update();
  }
}
