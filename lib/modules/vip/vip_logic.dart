import 'dart:async';

import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/modules/vip/model/payBean.dart';
import 'package:zpw/modules/vip/model/vipBean.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:zpw/utils/my_plugin.dart';
import 'package:tobias/tobias.dart';
import 'vip_state.dart';
import 'package:url_launcher/url_launcher.dart';

class VipLogic extends BaseGetxController {
  final VipState state = VipState();
  int payKeyType = 0;
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _conditionMet = false;

  @override
  void onInit() {
    super.onInit();
    getVipHome();
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _elapsedSeconds += 2;
      Log.d("el----$_elapsedSeconds");
      // 检查条件
      if (HandleTool.instance.isMember ||
          _conditionMet ||
          _elapsedSeconds >= 180) {
        stopPolling();
      } else {
        getUserInfo();
      }
    });
  }
  void stopPolling() {
    _timer?.cancel();
  }
  selectItem(int index) {
    state.itemIndex = index;
    update();
  }
  onSelected(bool isCheck) {
    state.isCheck.value = isCheck;
    update();
  }
  getVipHome() {
    Post<VipBean>(Api.vip_getVipHome,
        isShowProgress: true,
        success: (isSuccess, code, message, results) {
          Log.d("vip0000----$isSuccess----$results");
          if (isSuccess == true && results.isNotEmpty) {
            state.vipBean = results.first;
            if (state.vipBean.vipList == null ||
                state.vipBean.vipList?.length == 0) {
              HandleTool.showAppToastText("暂无会员套餐");
            } else {
              payKeyType =
                  state.vipBean.vipList?[0].vipPriceOutput?.defaultPayKeyType ??
                      0;
            }
            update();
          }
        },
        onModel: (m) => VipBean.fromJson(m));
  }

  addOrder(int goodsId) async {
    String channel = await getChannelInfo(3);
    Map<String, dynamic> dataMap = {
      "channel": channel,
      "goodsId": goodsId,
      "payKeyType": payKeyType,
    };
    Log.d("map----$dataMap");
    Post<PayBean>(Api.payOrder_addOrder,
        isShowProgress: true,
        params: dataMap,
        success: (isSuccess, code, message, results) {
          Log.i("------$results $isSuccess=========");
          if (isSuccess == true && results.isNotEmpty) {
            state.payBean = results.first;
            Tobias tobias = Tobias();
            if (state.payBean.payKeyType == 0 ||
                state.payBean.payKeyType == 4) {
              tobias
                  .pay(state.payBean.zfbPayOrderVo!.trademsg.toString())
                  .then((value) {
                if ("${value["resultStatus"]}" == "9000") {
                  HandleTool.instance.isMember = true;
                  HandleTool.showAppToastText("支付成功");
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
    // final MineLogic mineLogic = Get.find<MineLogic>();
    // Get<UserInfoBean>(Api.sso_getUserInfo,
    //     isShowProgress: false,
    //     success: (isSuccess, code, message, results) {
    //       if (isSuccess == true && results.isNotEmpty) {
    //         Log.d("is----${results.first}");
    //         mineLogic.state.userInfoBean = results.first;
    //         HandleTool.instance.isMember =
    //             mineLogic.state.userInfoBean.isMember ?? false;
    //         if (HandleTool.instance.isMember) {
    //           _conditionMet = true;
    //           HandleTool.showAppToastText("您已成为会员");
    //           String phones = mineLogic.state.userInfoBean.userPhone ?? "";
    //           if (phones.isNotEmpty) {
    //             return;
    //           }
    //         }
    //         update();
    //       }
    //     },
    //     onModel: (m) => UserInfoBean.fromJson(m));
  }
}
