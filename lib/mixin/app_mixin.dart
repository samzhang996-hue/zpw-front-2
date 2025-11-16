import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:zpw/utils/log_utils.dart';

import '../common/comm_wx_login_bottom_sheet.dart';
import '../modules/gameplay/gameplay_logic.dart';
import '../modules/main/model/user_info_bean.dart';
import '../modules/mine/mine_logic.dart';
import '../network/api_config.dart';
import '../network/http_client.dart';
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

        try {
          final response = await HttpClient().post(
            ApiConfig.authorizeByWx,
            data: {'code': result, 'userDeviceInfo': await (HandleTool.instance.getMap())},
          );

          if (response.isSuccess && response.data != null) {
            HandleTool.showAppToastText('登录成功');
            Map data = response.data as Map;
            SpUtils.setString("token", data['token'] ?? "");
            HandleTool.instance.token = data['token'] ?? "";

            try {
              final userResponse = await HttpClient().post(
                ApiConfig.sso_getUserInfo,
                showLoading: true,
              );

              if (userResponse.isSuccess && userResponse.data != null) {
                final Map userData = userResponse.data as Map;
                mineLogic.state.userInfoBean = UserInfoBean.fromJson(userData as Map<String, dynamic>);
                HandleTool.instance.isMember = mineLogic.state.userInfoBean.vipFlag == 1;
                final logic = Get.find<GameplayLogic>();
                logic.stateShowVip(HandleTool.instance.isMember);
                mineLogic.update();
                tempCom.complete(true);
              } else {
                tempCom.complete(true);
              }
            } catch (e) {
              tempCom.complete(true);
            }
          } else {
            tempCom.complete(false);
          }
        } catch (e) {
          tempCom.complete(false);
        }
      }
      return tempCom.future;
    }
    return true;
  }
}
