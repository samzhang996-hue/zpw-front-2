import 'dart:async';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tobias/tobias.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/mixin/app_mixin.dart';
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

class VipLogic extends BaseGetxController with AppMixin {
  final VipState state = VipState();
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _conditionMet = false;
  late BuyEngin buyEngin;
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
    buyEngin = BuyEngin();
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
    Post(Api.payOrder_restoreIosPay, isShowProgress: true, params: {
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

    Post(Api.payOrder_iosPay, isShowProgress: true, params: dataMap, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        // HandleTool.showAppToastText("购买成功");
        // getVipHome();
        if (click) {
          timerGetUserInfo();
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
          Log.d("vip0000----$isSuccess----${results.first.vipList?.length}");
          if (isSuccess == true && results.isNotEmpty) {
            state.vipBean = results.first;
            Log.d("vip111----$isSuccess----${results.first.toJson()}");
            if (state.vipBean.vipList == null || state.vipBean.vipList?.length == 0) {
              HandleTool.showAppToastText("暂无会员套餐");
            } else {
              state.payKeyType = state.vipBean.vipList?[0].vipPriceOutput?.defaultPayKeyType ?? 0;
            }
            update();
          } else {
            state.vipBean = state.normalVipBean;
            update();
          }
        },
        onModel: (m) => VipBean.fromJson(m));
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
        HandleTool.showAppToastText('未查询到会员信息，请回到首页稍后刷新');
        timer.cancel();
      }
      count++;
      getUserInfo();
      if (HandleTool.instance.isMember) {
        EasyLoading.dismiss();
        timer.cancel();
        Get.until((route) => route.isFirst);
      }
    });
  }

  addUserAgreementOrder() async {
    if ((await wxLogin() == true)) {
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
  }

  addOrder() async {
    // String msg="alipays://platformapi/startApp?appId=60000157&orderStr=app_id%3D2021004196632496%26method%3Dalipay.trade.app.pay%26charset%3DUTF-8%26version%3D1.0%26sign_type%3DRSA2%26notify_url%3Dhttp%253A%252F%252Fpayapi.changfu0591.top%252Fpayapi%252FzftNotify%252Fnotify%26biz_content%3D%257B%2522sub_merchant%2522%253A%257B%2522merchant_id%2522%253A%25222088460567345897%2522%257D%252C%2522out_trade_no%2522%253A%252220250306171034985132110%2522%252C%2522total_amount%2522%253A%25220.11%2522%252C%2522subject%2522%253A%2522%255Cu7528%255Cu6237%255Cu53f7%253A279516079%255Cuff0c%255Cu82e5%255Cu9700%255Cu9000%255Cu6b3e%255Cu6253%255Cu5ba2%255Cu670d%255Cu7535%255Cu8bdd%253A4000732899%2522%252C%2522product_code%2522%253A%2522GENERAL_WITHHOLDING%2522%252C%2522extend_params%2522%253A%257B%2522sys_service_provider_id%2522%253A%25222088941700930254%2522%257D%252C%2522disable_pay_channels%2522%253A%2522%2522%252C%2522settle_info%2522%253A%257B%2522settle_detail_infos%2522%253A%255B%257B%2522trans_in_type%2522%253A%2522defaultSettle%2522%252C%2522amount%2522%253A%25220.11%2522%257D%255D%257D%252C%2522time_expire%2522%253A%25222025-03-06%2B17%253A15%253A34%2522%252C%2522agreement_sign_params%2522%253A%257B%2522product_code%2522%253A%2522GENERAL_WITHHOLDING%2522%252C%2522personal_product_code%2522%253A%2522CYCLE_PAY_AUTH_P%2522%252C%2522sign_scene%2522%253A%2522INDUSTRY%257CDEFAULT_SCENE%2522%252C%2522access_params%2522%253A%257B%2522channel%2522%253A%2522ALIPAYAPP%2522%257D%252C%2522period_rule_params%2522%253A%257B%2522period_type%2522%253A%2522DAY%2522%252C%2522period%2522%253A%252230%2522%252C%2522execute_time%2522%253A%25222025-03-06%2522%252C%2522single_amount%2522%253A%252210.0%2522%257D%252C%2522sub_merchant%2522%253A%257B%2522sub_merchant_id%2522%253A%25222088460567345897%2522%252C%2522sub_merchant_name%2522%253A%2522%255Cu56db%255Cu5ddd%255Cu4e59%255Cu8212%255Cu79d1%255Cu6280%255Cu6709%255Cu9650%255Cu516c%255Cu53f8%2522%252C%2522sub_merchant_service_name%2522%253A%2522%255Cu4f1a%255Cu5458%255Cu7eed%255Cu8d39%2522%257D%252C%2522external_agreement_no%2522%253A%2522202503061710340011659663%2522%252C%2522sign_notify_url%2522%253A%2522http%253A%255C%252F%255C%252Fpayapi.changfu0591.top%255C%252Fpayapi%255C%252FzftNotify%255C%252FsignNotify%2522%257D%257D%26timestamp%3D2025-03-06%2B17%253A10%253A34%26app_cert_sn%3D8085ea6a9ea55f81f9441c947936d1c2%26alipay_root_cert_sn%3D687b59193f3f462dd5336e5abf83c5d8_02941eef3187dddf3d3b83462e1dfcf6%26sign%3DUMA5fUg%252BMZC4d0KLMLOvxrC5nAZ2hG0rSrM9UyfMnXlPWAEwsdn%252B8oFhgTTrU1Dv%252Fumymao8hGgsiSXFYtiAVC69SrdAntZ8H6z2RjdKjcb5sEC3fsGPTNEeJHS8Eo8aUyFVuTsQmBxlKAK9dk10qofX21UoXmla9QaNQhyufqPJKDjdCO3Anc91dspXtZ2StZQ0fVv36SU4qQIdFI8F2Z7Os4kIm7OTVCAdlMRTfFCfK2dpKyC4BhzSK6T2sgRq8L2RR3QND5eUbWbElAmuC8h5aJAo5dtoHMa%252FhvkdZk8rxe3mzZuIDi%252FdU%252Bo95b5hNfAUWC%252BSm6SYPNYp1Fnrww%253D%253D";
    // toUrl2(msg);
    // Tobias tobias = Tobias();
    // tobias.pay(msg).then((value) {
    //   if ("${value["resultStatus"]}" == "9000") {
    //     HandleTool.instance.isMember = true;
    //     HandleTool.showAppToastText("支付成功");
    //     // _startPolling();
    //   } else {
    //     HandleTool.showAppToastText("支付失败");
    //   }
    // });

    // String channel = await getChannelInfo(3);

    if ((await wxLogin() == true)) {
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
  }

  Future<void> toUrl2(String url) async {
    await launch(url);
  }

  void resumePurchase() async {
    if ((await wxLogin() == true)) {
      // getUserInfo();
      buyEngin.resumePurchase();
    }
  }

  getUserInfo() {
    final MineLogic mineLogic = Get.find<MineLogic>();

    mineLogic.getUserInfo();
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
                if (click) {
                  if (showToast) {
                    HandleTool.showAppToastText("您已成为会员");
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
        },
        onModel: (m) => UserInfoBean.fromJson(m));
  }
}
