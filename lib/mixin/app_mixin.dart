import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:zpw/utils/log_utils.dart';

import '../common/comm_wx_login_bottom_sheet.dart';
import '../modules/gameplay/gameplay_logic.dart';
import '../modules/main/model/user_info_bean.dart';
import '../modules/mine/mine_logic.dart';
import '../network/api/network_api.dart';
import '../utils/handle_tool.dart';
import '../utils/sp_utils.dart';

mixin AppMixin {
  Future<bool?> wxLogin() async {
    final mineLogic = Get.find<MineLogic>();
    // final isEmpty = HandleTool.instance.isEmpty(mineLogic.state.userInfoBean.nickName);
    // Log.e('isEmpty:$isEmpty');
    final isEmpty = HandleTool.instance.isEmpty(await SpUtils.getString("token"));
    if (isEmpty) {
      final result = await Get.bottomSheet<String?>(const CommWxLoginBottomSheet());
      final tempCom = Completer<bool>();
      if (HandleTool.instance.isNotEmpty(result)) {
        EasyLoading.show();
        HandleTool.instance.SMWPost(
          Api.authorizeByWx,
          params: {'code': result, 'userDeviceInfo': await (HandleTool.instance.getMap())},
          success: (isSuccess, code, message, results) async {
            if (isSuccess && results.isNotEmpty) {
              HandleTool.showAppToastText('登录成功');
              Map data = results.first as Map;
              SpUtils.setString("token", data['token'] ?? "");
              HandleTool.instance.token = data['token'] ?? "";
              HandleTool.instance.SMWPost<UserInfoBean>(Api.sso_getUserInfo,
                  isShowProgress: true,
                  success: (isSuccess, code, message, results) {
                    if (isSuccess == true && results.isNotEmpty) {
                      mineLogic.state.userInfoBean = results.first;
                      HandleTool.instance.isMember = mineLogic.state.userInfoBean.vipFlag == 1;
                      final logic = Get.find<GameplayLogic>();
                      logic.stateShowVip(HandleTool.instance.isMember);
                      mineLogic.update();
                      tempCom.complete(true);
                    } else {
                      Log.e('--------------message:$results');
                      tempCom.complete(true);
                    }
                  },
                  onModel: (m) => UserInfoBean.fromJson(m));
            } else {
              Log.e('--------------message:$results');
              tempCom.complete(false);
            }
          },
        );
      }
      return tempCom.future;
    }
    Log.e('isEmpty---:$isEmpty');
    return true;
  }
}
