import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:tobias/tobias.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/main/model/user_info_bean.dart';
import 'package:zpw/modules/mine/mine_logic.dart';
import 'package:zpw/modules/vip/model/payBean.dart';
import 'package:zpw/modules/vip/model/vipBean.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/buy_engine.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:zpw/utils/my_plugin.dart';

import 'vip_state.dart';

class VipLogic extends BaseGetxController {
  final VipState state = VipState();
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _conditionMet = false;
  late BuyEngin buyEngin;
  var click = false;
  var _success = false;
  bool isAt = false;

  @override
  void onInit() {
    super.onInit();
    var map = Get.arguments;
    if (map != null) {
      state.type = map["type"] ?? 0;
      update();
    }
    getVipHome();
    buyEngin = BuyEngin();
    buyEngin.initializeInAppPurchase();
    buyEngin.clearPendingPurchases();
  }

  @override
  void dispose() {
    buyEngin.onCloseIos();
    super.dispose();
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _elapsedSeconds += 2;
      Log.d("el----$_elapsedSeconds");
      // 检查条件
      if (HandleTool.instance.isMember || _conditionMet || _elapsedSeconds >= 180) {
        stopPolling();
      } else {
        getUserInfo();
      }
    });
  }

  void stopPolling() {
    _timer?.cancel();
  }

  restoreIosPay(dynamic receiptData, String transactionId, {bool showSuccessTips = true}) {
    Log.i("------click : $click=========");
    Post(Api.payOrder_restoreIosPay, isShowProgress: false, params: {
      "receiptData": receiptData,
      "transactionId": transactionId,
      "isRestore": true,
      "orderId": "",
    }, success: (isSuccess, code, message, results) {
      // Log.i("------${results.first} ${isSuccess}=========");
      if (isSuccess == true && results.isNotEmpty) {
        // HandleTool.showAppToastText("恢复成功");

        if (click) {
          getUserInfo();
        }
      }
    });
  }

  iosPay(dynamic receiptData, String transactionId) {
    Map<String, dynamic> dataMap = {"transactionId": transactionId, "receiptData": receiptData, "orderId": "", "isRestore": false};

    Log.i("------click : $click=========");

    Post(Api.payOrder_iosPay, isShowProgress: false, params: dataMap, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        // HandleTool.showAppToastText("购买成功");
        // getVipHome();
        if (click) {
          getUserInfo();
        }
      }
    });
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

  getVipHome() {
    Post<VipBean>(Api.vip_getVipHome,
        isShowProgress: true,
        success: (isSuccess, code, message, results) {
          Log.d("vip0000----$isSuccess----$results");
          if (isSuccess == true && results.isNotEmpty) {
            state.vipBean = results.first;
            if (state.vipBean.vipList == null || state.vipBean.vipList?.length == 0) {
              HandleTool.showAppToastText("暂无会员套餐");
            } else {
              state.payKeyType = state.vipBean.vipList?[0].vipPriceOutput?.defaultPayKeyType ?? 0;
            }
            update();
          }
        },
        onModel: (m) => VipBean.fromJson(m));
  }

  Future<void> test(String url) async {
    await setOrderZfb(url);
  }

  addUserAgreementOrder() {
    Map<String, dynamic> dataMap = {
      "goodsId": state.goodsId,
      "payKeyType": state.payKeyType,
    };
    Post(Api.payOrder_addUserAgreementOrder, isShowProgress: true, params: dataMap, success: (isSuccess, code, message, results) {
      Log.i("------${results.first} ");
      if (isSuccess == true && results.isNotEmpty) {
        var result = results[0];
        if (Platform.isAndroid) {
          isAt = true;
          test(result.toString());
        } else {
          //ios
        }
      }
    });
  }

  addOrder() async {
    // String channel = await getChannelInfo(3);
    Map<String, dynamic> dataMap = {
      // "channel": channel,
      "goodsId": state.goodsId,
      "payKeyType": state.payKeyType,
    };
    Log.d("map----$dataMap");
    Post<PayBean>(Api.payOrder_addOrder,
        isShowProgress: true,
        params: dataMap,
        success: (isSuccess, code, message, results) {
          Log.i("------${results.first.toJson()} $isSuccess=========");
          if (isSuccess == true && results.isNotEmpty) {
            state.payBean = results.first;
            Tobias tobias = Tobias();
            if (state.payBean.payKeyType == 0 || state.payBean.payKeyType == 4) {
              tobias.pay(state.payBean.zfbPayOrderVo!.trademsg.toString()).then((value) {
                if ("${value["resultStatus"]}" == "9000") {
                  HandleTool.instance.isMember = true;
                  HandleTool.showAppToastText("支付成功");
                  // _startPolling();
                } else {
                  HandleTool.showAppToastText("支付失败");
                }
              });
            } else if (state.payBean.payKeyType == 3) {
              // ZfbServerPayOrderVo? zfbServerPayOrderVo =
              //     state.payBean.zfbServerPayOrderVo;
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
        },
        onModel: (m) => PayBean.fromJson(m));
  }

  Future<void> toUrl2(String url) async {
    await launch(url);
  }

  getUserInfo() {
    final MineLogic mineLogic = Get.find<MineLogic>();
    Post<UserInfoBean>(Api.sso_getUserInfo,
        isShowProgress: false,
        success: (isSuccess, code, message, results) async {
          if (isSuccess == true && results.isNotEmpty) {
            Log.d("is----${results.first}");
            mineLogic.state.userInfoBean = results.first;
            HandleTool.instance.isMember = mineLogic.state.userInfoBean.vipFlag == 1;
            if (HandleTool.instance.isMember) {
              _conditionMet = true;
              if (_success == false) {
                HandleTool.showAppToastText("您已成为会员");
              }
              _success = true;
              String phones = mineLogic.state.userInfoBean.userPhone ?? "";
              if (phones.isNotEmpty) {
                return;
              }
            }
            update();
          }
        },
        onModel: (m) => UserInfoBean.fromJson(m));
  }
}
