import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

import '../common/zpw_comm_wx_login_bottom_sheet.dart';
import '../modules/gameplay/gameplay_logic.dart';
import '../modules/main/model/user_info_bean.dart';
import '../modules/mine/mine_logic.dart';
import '../network/api/zpw_network_api.dart';
import '../network/zpw_network_util.dart';
import '../utils/zpw_handle_tool.dart';
import '../utils/zpw_sp_utils.dart';

mixin ZpwAppMixin {
  Future<bool?> zpwWxLogin() async {
    final zpwMineLogic = Get.find<MineLogic>();
    final zpwIsEmpty = ZpwHandleTool.instance.isEmpty(await ZpwSpUtils.getString("token"));
    if (zpwIsEmpty) {
      final zpwResult = await Get.bottomSheet<String?>(const ZpwCommWxLoginBottomSheet());
      if (ZpwHandleTool.instance.isNotEmpty(zpwResult)) {
        EasyLoading.show();
        // 微信授权登录
        final authResult = await ZpwDioUtils.instance.postAsync(
          ZpwApi.zpwAuthorizeByWx,
          params: {'code': zpwResult, 'userDeviceInfo': await (ZpwHandleTool.instance.getMap())},
        );
        if (authResult.isSuccess && authResult.hasData) {
          ZpwHandleTool.showAppToastText('登录成功');
          Map zpwData = authResult.first as Map;
          ZpwSpUtils.setString("token", zpwData['token'] ?? "");
          ZpwHandleTool.instance.token = zpwData['token'] ?? "";
          // 获取用户信息
          final userResult = await ZpwDioUtils.instance.postAsync<UserInfoBean>(
            ZpwApi.zpwSsoGetUserInfo,
            isShowProgress: true,
            onModel: (m) => UserInfoBean.fromJson(m),
          );
          if (userResult.isSuccess && userResult.hasData) {
            zpwMineLogic.state.userInfoBean = userResult.first!;
            ZpwHandleTool.instance.isMember = zpwMineLogic.state.userInfoBean.vipFlag == 1;
            final zpwLogic = Get.find<GameplayLogic>();
            zpwLogic.stateShowVip(ZpwHandleTool.instance.isMember);
            zpwMineLogic.update();
            return true;
          } else {
            ZpwLog.e('--------------message:${userResult.message}');
            return true;
          }
        } else {
          ZpwLog.e('--------------message:${authResult.message}');
          return false;
        }
      }
      return false;
    }
    ZpwLog.e('isEmpty---:$zpwIsEmpty');
    return true;
  }
}