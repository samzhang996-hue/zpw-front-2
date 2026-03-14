import 'dart:async';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tobias/tobias.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/mixin/zpw_app_mixin.dart';
import 'package:zpw/modules/main/model/zpw_user_info_bean.dart';
import 'package:zpw/modules/mine/zpw_mine_logic.dart';
import 'package:zpw/modules/vip/model/zpw_payBean.dart';
import 'package:zpw/modules/vip/model/zpw_vipBean.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_buy_engine.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';
import 'package:zpw/utils/zpw_my_plugin.dart';

import 'zpw_vip_state.dart';

class VipLogic extends ZpwBaseGetxController with ZpwAppMixin {
  final VipState state = VipState();
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _conditionMet = false;
  late ZpwBuyEngin buyEngin;
  var click = false;
  var _success = false;
  bool isAt = false;

  bool canBack = true;

  bool showToast = true;

  @override
  void onInit() {
    super.onInit();
    var map = Get.arguments;
    if (map != null) {
      state.type = map["type"] ?? 0;
      update();
    }
    getVipHome();
    buyEngin = ZpwBuyEngin();
    buyEngin.initializeInAppPurchase();
    buyEngin.clearPendingPurchases();
  }

  @override
  void dispose() {
    // buyEngin.onCloseIos();
    super.dispose();
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _elapsedSeconds += 2;
      ZpwLog.d("el----$_elapsedSeconds");
      // 检查条件
      if (ZpwHandleTool.instance.isMember || _conditionMet || _elapsedSeconds >= 180) {
        stopPolling();
      } else {
        getUserInfo();
      }
    });
  }

  void stopPolling() {
    _timer?.cancel();
  }

  restoreIosPay(dynamic receiptData, String transactionId, {bool showSuccessTips = true}) async {
    ZpwLog.i("------click : $click=========");
    final result = await postAsync(ZpwApi.zpwPayOrderRestoreIosPay, isShowProgress: true, params: {
      "receiptData": receiptData,
      "transactionId": transactionId,
      "isRestore": true,
      "orderId": "",
    });
    if (result.isSuccess && result.hasData) {
      if (click) {
        getUserInfo();
      }
    }
  }

  iosPay(dynamic receiptData, String transactionId) async {
    Map<String, dynamic> dataMap = {"transactionId": transactionId, "receiptData": receiptData, "orderId": "", "isRestore": false};

    ZpwLog.i("------click : $click=========");

    final result = await postAsync(ZpwApi.zpwPayOrderIosPay, isShowProgress: true, params: dataMap);
    if (result.isSuccess && result.hasData) {
      if (click) {
        timerGetUserInfo();
      }
    }
  }

  selectItem(int index) {
    state.itemIndex = index;
    update();
  }

  onSelected(bool isCheck) {
    state.isCheck.value = isCheck;
    update();
  }

  onSatePay(int type) {
    state.statePay.value = type;
    update();
  }

  getVipHome() async {
    final result = await postAsync<ZpwVipBean>(
      ZpwApi.zpwVipGetVipHome,
      isShowProgress: true,
      onModel: (m) => ZpwVipBean.fromJson(m),
    );
    ZpwLog.d("vip0000----${result.isSuccess}----${result.first?.vipList?.length}");
    if (result.isSuccess && result.hasData) {
      state.vipBean = result.first!;
      ZpwLog.d("vip111----${result.isSuccess}----${result.first!.toJson()}");
      if (state.vipBean.vipList == null || state.vipBean.vipList?.length == 0) {
        ZpwHandleTool.showAppToastText("暂无会员套餐");
      } else {
        state.payKeyType = state.vipBean.vipList?[0].vipPriceOutput?.defaultPayKeyType ?? 0;
      }
      update();
    } else {
      state.vipBean = state.normalVipBean;
      update();
    }
  }

  Future<void> test(String url) async {
    await setOrderZfb(url);
  }

  /// 1分钟内每3s获取一次用户信息，超过1分钟则停止
  void timerGetUserInfo() {
    int count = 0;
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (count >= 20) {
        EasyLoading.dismiss();
        ZpwHandleTool.showAppToastText('未查询到会员信息，请回到首页稍后刷新');
        timer.cancel();
      }
      count++;
      getUserInfo();
      if (ZpwHandleTool.instance.isMember) {
        EasyLoading.dismiss();
        timer.cancel();
        Get.until((route) => route.isFirst);
      }
    });
  }

  addUserAgreementOrder() async {
    if ((await zpwWxLogin() == true)) {
      Map<String, dynamic> dataMap = {
        "goodsId": state.goodsId,
        "payKeyType": state.payKeyType,
      };
      final result = await postAsync(ZpwApi.zpwPayOrderAddUserAgreementOrder, isShowProgress: true, params: dataMap);
      ZpwLog.i("------${result.data} ");
      if (result.isSuccess && result.hasData) {
        var res = result.data[0];
        if (Platform.isAndroid) {
          isAt = true;
          test(res.toString());
        } else {
          //ios
        }
      }
    }
  }

  addOrder() async {
    if ((await zpwWxLogin() == true)) {
      Map<String, dynamic> dataMap = {
        "goodsId": state.goodsId,
        "payKeyType": state.payKeyType,
      };
      ZpwLog.d("map----$dataMap");
      final result = await postAsync<ZpwPayBean>(
        ZpwApi.zpwPayOrderAddOrder,
        isShowProgress: true,
        params: dataMap,
        onModel: (m) => ZpwPayBean.fromJson(m),
      );
      ZpwLog.i("------${result.first?.toJson()} ${result.isSuccess}=========");
      if (result.isSuccess && result.hasData) {
        state.payBean = result.first!;
        Tobias tobias = Tobias();
        if (state.payBean.payKeyType == 0 || state.payBean.payKeyType == 4) {
          tobias.pay(state.payBean.zfbPayOrderVo!.trademsg.toString()).then((value) {
            if ("${value["resultStatus"]}" == "9000") {
              ZpwHandleTool.instance.isMember = true;
              ZpwHandleTool.showAppToastText("支付成功");
            } else {
              ZpwHandleTool.showAppToastText("支付失败");
            }
          });
        } else if (state.payBean.payKeyType == 3) {
          // ZfbServerPayOrderVo? zfbServerPayOrderVo = state.payBean.zfbServerPayOrderVo;
          // if (zfbServerPayOrderVo != null) {
          //   htmlFlutter(
          //       zfbServerPayOrderVo.appId ?? "",
          //       zfbServerPayOrderVo.jumpUrl ?? "",
          //       zfbServerPayOrderVo.outTradeNo ?? "");
          //   _startPolling();
          // }
        } else if (state.payBean.payKeyType == 5) {
          onH5(state.payBean.zfbPayOrderVo!.trademsg.toString());
        } else if (state.payBean.payKeyType == 6) {
          toUrl2(state.payBean.zfbPayOrderVo!.trademsg.toString());
        }
      }
    }
  }

  Future<void> toUrl2(String url) async {
    await launch(url);
  }

  getUserInfo() async {
    final MineLogic mineLogic = Get.find<MineLogic>();

    mineLogic.getUserInfo();
    final result = await postAsync<UserInfoBean>(
      ZpwApi.zpwSsoGetUserInfo,
      isShowProgress: false,
      onModel: (m) => UserInfoBean.fromJson(m),
    );
    if (result.isSuccess && result.hasData) {
      ZpwLog.d("is----${result.first}");
      mineLogic.state.userInfoBean = result.first!;
      ZpwHandleTool.instance.isMember = mineLogic.state.userInfoBean.vipFlag == 1;
      if (ZpwHandleTool.instance.isMember) {
        _conditionMet = true;
        if (_success == false) {
          if (click) {
            if (showToast) {
              ZpwHandleTool.showAppToastText("您已成为会员");
            }
          }
          if (canBack) {
            Get.back();
          }
        }
        _success = true;
        String phones = mineLogic.state.userInfoBean.userPhone ?? "";
        if (phones.isNotEmpty) {
          return;
        }
      }
      update();
    }
  }
}