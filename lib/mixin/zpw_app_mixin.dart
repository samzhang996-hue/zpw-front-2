import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import '../common/zpw_comm_wx_login_bottom_sheet.dart';
import '../modules/gameplay/gameplay_logic.dart';
import '../modules/main/model/user_info_bean.dart';
import '../modules/mine/mine_logic.dart';
import '../network/api/zpw_network_api.dart';
import '../utils/zpw_handle_tool.dart';
import '../utils/zpw_sp_utils.dart';

mixin ZpwAppMixin {
  Future<bool?> zpwWxLogin() async {
    final zpwMineLogic = Get.find<MineLogic>();
    // final isEmpty = ZpwHandleTool.instance.isEmpty(zpwMineLogic.state.userInfoBean.nickName);
    // ZpwLog.e('isEmpty:$isEmpty');
    final zpwIsEmpty = ZpwHandleTool.instance.isEmpty(await ZpwSpUtils.getString("token"));
    if (zpwIsEmpty) {
      final zpwResult = await Get.bottomSheet<String?>(const ZpwCommWxLoginBottomSheet());
      final zpwTempCom = Completer<bool>();
      if (ZpwHandleTool.instance.isNotEmpty(zpwResult)) {
        EasyLoading.show();
        ZpwHandleTool.instance.SMWPost(
          ZpwApi.zpwAuthorizeByWx,
          params: {'code': zpwResult, 'userDeviceInfo': await (ZpwHandleTool.instance.getMap())},
          success: (isSuccess, code, message, results) async {
            if (isSuccess && results.isNotEmpty) {
              ZpwHandleTool.showAppToastText('登录成功');
              Map zpwData = results.first as Map;
              ZpwSpUtils.setString("token", zpwData['token'] ?? "");
              ZpwHandleTool.instance.token = zpwData['token'] ?? "";
              ZpwHandleTool.instance.SMWPost<UserInfoBean>(ZpwApi.zpwSsoGetUserInfo,
                  isShowProgress: true,
                  success: (isSuccess, code, message, results) {
                    if (isSuccess == true && results.isNotEmpty) {
                      zpwMineLogic.state.userInfoBean = results.first;
                      ZpwHandleTool.instance.isMember = zpwMineLogic.state.userInfoBean.vipFlag == 1;
                      final zpwLogic = Get.find<GameplayLogic>();
                      zpwLogic.stateShowVip(ZpwHandleTool.instance.isMember);
                      zpwMineLogic.update();
                      zpwTempCom.complete(true);
                    } else {
                      ZpwLog.e('--------------message:$results');
                      zpwTempCom.complete(true);
                    }
                  },
                  onModel: (m) => UserInfoBean.fromJson(m));
            } else {
              ZpwLog.e('--------------message:$results');
              zpwTempCom.complete(false);
            }
          },
        );
      }
      return zpwTempCom.future;
    }
    ZpwLog.e('isEmpty---:$zpwIsEmpty');
    return true;
  }
}