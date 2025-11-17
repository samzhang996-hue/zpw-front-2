import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tobias/tobias.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:zpw/common/constant.dart';
import 'package:zpw/common/view/comm_text.dart';
import 'package:zpw/common/view/my_web_view/my_web_view_view.dart';
import 'package:zpw/mixin/app_mixin.dart';
import 'package:zpw/modules/main/model/user_info_bean.dart';
import 'package:zpw/modules/mine/mine_logic.dart';
import 'package:zpw/modules/vip/model/payBean.dart';
import 'package:zpw/modules/vip/model/vipBean.dart';
import 'package:zpw/modules/vip/view/custom_exit_vip_dialog_utils.dart';
import 'package:zpw/modules/vip/view/custom_sure_vip_dialog_utils.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
import 'package:zpw/utils/buy_engine.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/my_plugin.dart';

class VipPage extends StatefulWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  State<VipPage> createState() => _VipPageState();
}

class _VipPageState extends State<VipPage> with WidgetsBindingObserver, AppMixin {
  // VideoPlayer controller
  late VideoPlayerController _controller;

  // State variables from vip_state.dart
  int itemIndex = 0;
  int type = 0;
  bool isCheck = false;
  late PayBean payBean;
  late VipBean vipBean;
  int payKeyType = 0;
  int goodsId = 0;
  int isWx = 0;
  int isZfb = 0;
  int statePay = 0;
  late VipBean normalVipBean;

  // Logic variables from vip_logic.dart
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _conditionMet = false;
  late BuyEngin buyEngin;
  bool click = false;
  bool _success = false;
  bool isAt = false;
  bool canBack = true;
  bool showToast = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        getUserInfo();
        getVipHome();
        break;
      case AppLifecycleState.hidden:
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize state variables
    _initializeState();

    // Initialize video controller
    _controller = VideoPlayerController.asset('vip.mp4'.vip)
      ..setLooping(true)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _controller.play();
          });
        }
      });

    // Initialize logic
    var map = Get.arguments;
    if (map != null) {
      type = map["type"] ?? 0;
    }
    getVipHome();
    buyEngin = BuyEngin();
    buyEngin.initializeInAppPurchase();
    buyEngin.clearPendingPurchases();
  }

  void _initializeState() {
    payBean = PayBean();
    vipBean = VipBean();
    normalVipBean = Platform.isIOS
        ? VipBean.fromJson({
            "id": 149,
            "channel": "DNXJIOS",
            "createTime": "2025-01-18 14:40:48",
            "projectId": 30,
            "vipList": [
              {
                "showRemark": "",
                "remark1": "最多人购买",
                "remark2": "年卡",
                "remark3": "198",
                "remark4": "原价468",
                "remark5": "",
                "remark6": "",
                "remark7": "",
                "remark8": "立即开通",
                "remark9": "周期会员到期自动续费，可退订",
                "remark10": "",
                "vipPriceId": 105,
                "isPayOne": null,
                "sortId": 0,
                "vipPriceOutput": {
                  "id": 105,
                  "showName": "普通支付-198.00元/365天",
                  "price": 19800,
                  "originalPrice": null,
                  "vipTime": 365,
                  "vipTimeType": "DAY",
                  "vipName": null,
                  "isZfbPay": 0,
                  "isWxPay": 0,
                  "isIosPay": 1,
                  "payName": null,
                  "iosProductId": "ai_year",
                  "isWithdrawal": 0,
                  "agreemenType": null,
                  "agreemenPrice": null,
                  "agreemenTime": null,
                  "agreemenTimeType": null,
                  "agreemenPayments": null,
                  "collTime": null,
                  "collTimeType": null,
                  "agreemenPayNum": null,
                  "decreaseMoney": null,
                  "isDisposable": 0,
                  "defaultZfbPayKeyType": null,
                  "defaultPayKeyType": 2
                }
              },
              {
                "showRemark": "",
                "remark1": "",
                "remark2": "月卡",
                "remark3": "38",
                "remark4": "原价58",
                "remark5": "",
                "remark6": "",
                "remark7": "",
                "remark8": "立即开通",
                "remark9": "周期会员到期自动续费，可退订",
                "remark10": "",
                "vipPriceId": 107,
                "isPayOne": null,
                "sortId": 0,
                "vipPriceOutput": {
                  "id": 107,
                  "showName": "普通支付-38.00元/30天",
                  "price": 3800,
                  "originalPrice": null,
                  "vipTime": 30,
                  "vipTimeType": "DAY",
                  "vipName": null,
                  "isZfbPay": 0,
                  "isWxPay": 0,
                  "isIosPay": 1,
                  "payName": null,
                  "iosProductId": "ai_month",
                  "isWithdrawal": 0,
                  "agreemenType": null,
                  "agreemenPrice": null,
                  "agreemenTime": null,
                  "agreemenTimeType": null,
                  "agreemenPayments": null,
                  "collTime": null,
                  "collTimeType": null,
                  "agreemenPayNum": null,
                  "decreaseMoney": null,
                  "isDisposable": 0,
                  "defaultZfbPayKeyType": null,
                  "defaultPayKeyType": 2
                }
              },
              {
                "showRemark": "",
                "remark1": "",
                "remark2": "季卡",
                "remark3": "98",
                "remark4": "原价128",
                "remark5": "",
                "remark6": "",
                "remark7": "",
                "remark8": "立即开通",
                "remark9": "周期会员到期自动续费，可退订",
                "remark10": "",
                "vipPriceId": 106,
                "isPayOne": null,
                "sortId": 0,
                "vipPriceOutput": {
                  "id": 106,
                  "showName": "普通支付-98.00元/90天",
                  "price": 9800,
                  "originalPrice": null,
                  "vipTime": 90,
                  "vipTimeType": "DAY",
                  "vipName": null,
                  "isZfbPay": 0,
                  "isWxPay": 0,
                  "isIosPay": 1,
                  "payName": null,
                  "iosProductId": "ai_quarter",
                  "isWithdrawal": 0,
                  "agreemenType": null,
                  "agreemenPrice": null,
                  "agreemenTime": null,
                  "agreemenTimeType": null,
                  "agreemenPayments": null,
                  "collTime": null,
                  "collTimeType": null,
                  "agreemenPayNum": null,
                  "decreaseMoney": null,
                  "isDisposable": 0,
                  "defaultZfbPayKeyType": null,
                  "defaultPayKeyType": 2
                }
              }
            ],
            "vipPopList": [],
            "homePopList": [],
            "contentPopList": [],
            "otherPopList": []
          })
        : VipBean.fromJson({
            "code": 100,
            "message": "成功",
            "data": {
              "id": 148,
              "channel": "AIJL300",
              "createTime": "2025-01-18 14:40:25",
              "projectId": 30,
              "vipList": [
                {
                  "showRemark": "",
                  "remark1": "最多人购买",
                  "remark2": "免费试用",
                  "remark3": "0.1",
                  "remark4": "原价98",
                  "remark5": "",
                  "remark6": "",
                  "remark7": "",
                  "remark8": "立即开通",
                  "remark9": "周期会员到期自动续费，可退订",
                  "remark10": "",
                  "vipPriceId": 83,
                  "isPayOne": null,
                  "sortId": 4,
                  "vipPriceOutput": {
                    "id": 83,
                    "showName": "支付0.10元/1天-付款后签约-每期98.00元/30天-老账号价格-1时后扣款",
                    "price": 10,
                    "originalPrice": null,
                    "vipTime": 1,
                    "vipTimeType": "DAY",
                    "vipName": null,
                    "isZfbPay": 1,
                    "isWxPay": 0,
                    "isIosPay": 0,
                    "payName": null,
                    "iosProductId": null,
                    "isWithdrawal": 1,
                    "agreemenType": 1,
                    "agreemenPrice": 9800,
                    "agreemenTime": 30,
                    "agreemenTimeType": "DAY",
                    "agreemenPayments": 36,
                    "collTime": 1,
                    "collTimeType": "HOUR",
                    "agreemenPayNum": 3,
                    "decreaseMoney": 1000,
                    "isDisposable": 0,
                    "defaultZfbPayKeyType": 6,
                    "defaultPayKeyType": 6
                  }
                },
                {
                  "showRemark": "",
                  "remark1": "",
                  "remark2": "月卡",
                  "remark3": "69",
                  "remark4": "原价98",
                  "remark5": "",
                  "remark6": "",
                  "remark7": "",
                  "remark8": "立即开通",
                  "remark9": "周期会员到期自动续费，可退订",
                  "remark10": "",
                  "vipPriceId": 79,
                  "isPayOne": null,
                  "sortId": 0,
                  "vipPriceOutput": {
                    "id": 79,
                    "showName": "支付69.00元/1月-付款后签约-每期69.00元/30天-老账号价格-2天后扣款",
                    "price": 6900,
                    "originalPrice": null,
                    "vipTime": 1,
                    "vipTimeType": "MONTH",
                    "vipName": null,
                    "isZfbPay": 1,
                    "isWxPay": 0,
                    "isIosPay": 0,
                    "payName": null,
                    "iosProductId": null,
                    "isWithdrawal": 1,
                    "agreemenType": 1,
                    "agreemenPrice": 6900,
                    "agreemenTime": 30,
                    "agreemenTimeType": "DAY",
                    "agreemenPayments": 24,
                    "collTime": 2,
                    "collTimeType": "DAY",
                    "agreemenPayNum": 3,
                    "decreaseMoney": 500,
                    "isDisposable": 0,
                    "defaultZfbPayKeyType": null,
                    "defaultPayKeyType": 0
                  }
                },
                {
                  "showRemark": "",
                  "remark1": "",
                  "remark2": "年卡",
                  "remark3": "129",
                  "remark4": "原价198",
                  "remark5": "",
                  "remark6": "",
                  "remark7": "",
                  "remark8": "立即开通",
                  "remark9": "周期会员到期自动续费，可退订",
                  "remark10": "",
                  "vipPriceId": 24,
                  "isPayOne": null,
                  "sortId": 0,
                  "vipPriceOutput": {
                    "id": 24,
                    "showName": "支付89.00元/1年-付款后签约-每期89.00元/365天-新账号价格",
                    "price": 8900,
                    "originalPrice": null,
                    "vipTime": 1,
                    "vipTimeType": "YEAR",
                    "vipName": null,
                    "isZfbPay": 1,
                    "isWxPay": 0,
                    "isIosPay": 0,
                    "payName": null,
                    "iosProductId": null,
                    "isWithdrawal": 1,
                    "agreemenType": 1,
                    "agreemenPrice": 8900,
                    "agreemenTime": 365,
                    "agreemenTimeType": "DAY",
                    "agreemenPayments": 8900,
                    "collTime": null,
                    "collTimeType": null,
                    "agreemenPayNum": 3,
                    "decreaseMoney": null,
                    "isDisposable": 0,
                    "defaultZfbPayKeyType": 0,
                    "defaultPayKeyType": 0
                  }
                }
              ],
              "vipPopList": [],
              "homePopList": [],
              "contentPopList": [],
              "otherPopList": []
            }
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    canBack = false;
    showToast = false;
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // Logic methods from vip_logic.dart

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _elapsedSeconds += 2;
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

  Future<void> restoreIosPay(dynamic receiptData, String transactionId, {bool showSuccessTips = true}) async {
    try {
      final response = await HttpClient().post(
        ApiConfig.payOrder_restoreIosPay,
        data: {
          "receiptData": receiptData,
          "transactionId": transactionId,
          "isRestore": true,
          "orderId": "",
        },
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        if (dataList.isNotEmpty) {
          if (click) {
            getUserInfo();
          }
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  Future<void> iosPay(dynamic receiptData, String transactionId) async {
    Map<String, dynamic> dataMap = {
      "transactionId": transactionId,
      "receiptData": receiptData,
      "orderId": "",
      "isRestore": false
    };

    try {
      final response = await HttpClient().post(
        ApiConfig.payOrder_iosPay,
        data: dataMap,
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        if (dataList.isNotEmpty) {
          if (click) {
            timerGetUserInfo();
          }
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  void selectItem(int index) {
    if (mounted) {
      setState(() {
        itemIndex = index;
      });
    }
  }

  void onSelected(bool isCheckValue) {
    if (mounted) {
      setState(() {
        isCheck = isCheckValue;
      });
    }
  }

  void onSatePay(int type) {
    if (mounted) {
      setState(() {
        statePay = type;
      });
    }
  }

  Future<void> getVipHome() async {
    try {
      final response = await HttpClient().post(
        ApiConfig.vip_getVipHome,
        showLoading: true,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        final results = dataList.map((e) => VipBean.fromJson(e as Map<String, dynamic>)).toList();

        if (results.isNotEmpty) {
          if (mounted) {
            setState(() {
              vipBean = results.first;
              if (vipBean.vipList == null || vipBean.vipList!.isEmpty) {
                HandleTool.showAppToastText("暂无会员套餐");
              } else {
                payKeyType = vipBean.vipList?[0].vipPriceOutput?.defaultPayKeyType ?? 0;
              }
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            vipBean = normalVipBean;
          });
        }
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
      if (mounted) {
        setState(() {
          vipBean = normalVipBean;
        });
      }
    }
  }

  Future<void> test(String url) async {
    await setOrderZfb(url);
  }

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

  Future<void> addUserAgreementOrder() async {
    if ((await wxLogin() == true)) {
      Map<String, dynamic> dataMap = {
        "goodsId": goodsId,
        "payKeyType": payKeyType,
      };

      try {
        final response = await HttpClient().post(
          ApiConfig.payOrder_addUserAgreementOrder,
          data: dataMap,
          showLoading: true,
        );

        if (response.isSuccess && response.data != null) {
          final List<dynamic> dataList = response.data as List<dynamic>;
          if (dataList.isNotEmpty) {
            var result = dataList[0];
            if (Platform.isAndroid) {
              isAt = true;
              test(result.toString());
            }
          }
        } else {
          EasyLoading.showError(response.message);
        }
      } catch (e) {
        EasyLoading.showError('请求失败: $e');
      }
    }
  }

  Future<void> addOrder() async {
    if ((await wxLogin() == true)) {
      Map<String, dynamic> dataMap = {
        "goodsId": goodsId,
        "payKeyType": payKeyType,
      };

      try {
        final response = await HttpClient().post(
          ApiConfig.payOrder_addOrder,
          data: dataMap,
          showLoading: true,
        );

        if (response.isSuccess && response.data != null) {
          final List<dynamic> dataList = response.data as List<dynamic>;
          final results = dataList.map((e) => PayBean.fromJson(e as Map<String, dynamic>)).toList();

          if (results.isNotEmpty) {
            if (mounted) {
              setState(() {
                payBean = results.first;
              });
            }
            Tobias tobias = Tobias();
            if (payBean.payKeyType == 0 || payBean.payKeyType == 4) {
              tobias.pay(payBean.zfbPayOrderVo!.trademsg.toString()).then((value) {
                if ("${value["resultStatus"]}" == "9000") {
                  HandleTool.instance.isMember = true;
                  HandleTool.showAppToastText("支付成功");
                } else {
                  HandleTool.showAppToastText("支付失败");
                }
              });
            } else if (payBean.payKeyType == 5) {
              onH5(payBean.zfbPayOrderVo!.trademsg.toString());
            } else if (payBean.payKeyType == 6) {
              toUrl2(payBean.zfbPayOrderVo!.trademsg.toString());
            }
          }
        } else {
          EasyLoading.showError(response.message);
        }
      } catch (e) {
        EasyLoading.showError('请求失败: $e');
      }
    }
  }

  Future<void> toUrl2(String url) async {
    await launch(url);
  }

  void resumePurchase() async {
    if ((await wxLogin() == true)) {
      buyEngin.resumePurchase();
    }
  }

  Future<void> getUserInfo() async {
    final MineLogic mineLogic = Get.find<MineLogic>();

    mineLogic.getUserInfo();

    try {
      final response = await HttpClient().post(
        ApiConfig.sso_getUserInfo,
        showLoading: false,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        final results = dataList.map((e) => UserInfoBean.fromJson(e as Map<String, dynamic>)).toList();

        if (results.isNotEmpty) {
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
          if (mounted) {
            setState(() {});
          }
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? rk8;
    String? rk9;
    String? rk10;

    if (vipBean.vipList != null && vipBean.vipList!.isNotEmpty) {
      rk9 = vipBean.vipList?[itemIndex].remark9;
      rk8 = vipBean.vipList?[itemIndex].remark8;
      rk10 = vipBean.vipList?[itemIndex].remark10;
      isWx = vipBean.vipList?[itemIndex].vipPriceOutput?.isWxPay ?? 0;
      isZfb = vipBean.vipList?[itemIndex].vipPriceOutput?.isZfbPay ?? 0;
    } else {
      rk9 = "";
      rk8 = "";
      rk10 = "";
    }

    return PopScope(
      canPop: false,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  width: double.infinity,
                  height: 644.w,
                  color: const Color(0xff000000),
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0x00000000),
                          Color(0xff000000),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.2, 0.2],
                      ),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: CommText(
                            text: "会员无限制作 / 无水印 / 无广告 / 专属客服",
                            fontSize: 15.w,
                            textColor: const Color(0xffB2B2B2),
                            fontWeight: FontWeight.w500,
                          ),
                        ).paddingOnly(bottom: 6.w),
                        _listViewWidget(),
                        Visibility(
                          visible: !(rk9 == ""),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 16.w),
                              child: CommText(
                                text: rk9,
                                fontSize: 11.sp,
                                textColor: const Color(0xff7E7E7E),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: (isWx == 1 && isZfb == 1),
                          child: Container(
                            margin: EdgeInsets.only(top: 10.w, bottom: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Visibility(
                                    visible: isZfb == 1,
                                    child: InkWell(
                                      onTap: () {
                                        onSatePay(0);
                                      },
                                      child: SizedBox(
                                        height: 47.w,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "zfb.png".vip,
                                              width: 26.w,
                                            ),
                                            SizedBox(width: 8.w),
                                            CommText(
                                              text: "支付宝支付",
                                              fontSize: 15.w,
                                              textColor: const Color(0xffFFD9D0),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            SizedBox(width: 8.w),
                                            Image.asset(
                                              statePay != 1 ? "checked.png".vip : "un_check.png".vip,
                                              width: 14.w,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                Visibility(
                                  visible: isWx == 1,
                                  child: InkWell(
                                      onTap: () {
                                        onSatePay(1);
                                      },
                                      child: SizedBox(
                                        height: 47.w,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "wx.png".vip,
                                              width: 26.w,
                                            ),
                                            SizedBox(width: 8.w),
                                            CommText(
                                              text: "微信支付",
                                              fontSize: 15.w,
                                              textColor: const Color(0xffFFD9D0),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            SizedBox(width: 8.w),
                                            Image.asset(
                                              statePay == 1 ? "checked.png".vip : "un_check.png".vip,
                                              width: 14.w,
                                            ),
                                          ],
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            var vp = vipBean.vipList?[itemIndex].vipPriceOutput;
                            UmengCommonSdk.onEvent('Vip_click_event', {'name': '${vipBean.vipList?[itemIndex].remark2}'});
                            goodsId = vp?.id ?? 0;
                            if (statePay == 1) {
                              payKeyType = 1;
                            } else {
                              payKeyType = vp?.defaultPayKeyType ?? 0;
                            }

                            click = true;
                            if (isCheck) {
                              if (Platform.isIOS) {
                                buyEngin.buyProduct(vp?.iosProductId);
                                return;
                              }
                            }
                            isWx = vipBean.vipList?[itemIndex].vipPriceOutput?.isWxPay ?? 0;
                            isZfb = vipBean.vipList?[itemIndex].vipPriceOutput?.isZfbPay ?? 0;
                            if (!isCheck) {
                              CustomSureVipDialogUtils.showCustomDialog(
                                  context: context,
                                  onPressed: () {
                                    if (Platform.isIOS) {
                                      buyEngin.buyProduct(vp?.iosProductId);
                                      return;
                                    }
                                    onSelected(true);
                                    addOrder();
                                  });
                            } else {
                              addOrder();
                            }
                          },
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 17.w, right: 17.w, top: 17.w),
                                height: 54.w,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(27),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF7EFAEF), Color(0xFF7FE1FB)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                  ),
                                ),
                                child: Center(
                                    child: CommText(
                                  text: rk8,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  textColor: const Color(0xff191919),
                                )),
                              ),
                              Visibility(
                                visible: !(rk10 == ""),
                                child: Container(
                                  margin: EdgeInsets.only(right: 17.w),
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width: 183.w,
                                        height: 27.w,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage("vip_btn_tip.png".vip),
                                                fit: BoxFit.cover)),
                                        child: CommText(
                                          text: rk10,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          textColor: Colors.white,
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20.w, top: 10.w, bottom: 25.w),
                          child: Row(
                            children: [
                              InkWell(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      isCheck ? "checked.png".vip : "un_check.png".vip,
                                      width: 14.w,
                                    ),
                                    CommText(
                                      text: "点击购买即表示您同意",
                                      fontSize: 12.sp,
                                      textColor: const Color(0xff646464),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  onSelected(!isCheck);
                                },
                              ),
                              InkWell(
                                onTap: () {
                                  String htmlStr = HandleTool.instance.hYxy;
                                  if (htmlStr.isEmpty) {
                                    return;
                                  }
                                  gotoPushPage(
                                    MyWebViewPage(
                                      titleStr: "会员协议",
                                      htmlUrl: HandleTool.instance.hYxy,
                                    ),
                                  );
                                },
                                child: CommText(
                                  text: "《会员协议》",
                                  fontSize: 12.sp,
                                  textColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Container(
                        width: 80.w,
                        height: 30.w,
                        padding: EdgeInsets.only(left: 16.w, top: 4),
                        margin: EdgeInsets.only(top: 48.w, left: 0.w),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              "back.png".comm,
                              width: 16.w,
                            )),
                      ),
                      onTap: () {
                        if (HandleTool.instance.isMember) {
                          Get.back();
                        } else {
                          if (vipBean.vipPopList == null || vipBean.vipPopList!.isEmpty) {
                            Get.back();
                          } else {
                            CustomExitVipDialogUtils2.showCustomDialog(
                                context: context, onPressed: () {});
                          }
                        }
                      },
                    ),
                    Visibility(
                      visible: Platform.isIOS,
                      child: GestureDetector(
                        onTap: () {
                          click = true;
                          resumePurchase();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 28.w, right: 16.w),
                          child: const Text(
                            "恢复购买",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listViewWidget() {
    var vipPriceVos = vipBean.vipList;
    if (vipPriceVos == null || vipPriceVos.isEmpty) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.w),
      height: 165.w,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        scrollDirection: Axis.horizontal,
        itemCount: vipPriceVos.length,
        itemBuilder: (BuildContext context, int index) {
          var vp = vipPriceVos[index];
          bool isSelect = itemIndex == index;
          return InkWell(
            onTap: () {
              selectItem(index);
              statePay = vp.vipPriceOutput?.defaultPayKeyType ?? 0;
              if (mounted) {
                setState(() {});
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 9.w),
              child: Stack(
                children: [
                  SizedBox(
                    height: 146.w,
                    child: Container(
                      width: 114.w,
                      height: 136.w,
                      margin: EdgeInsets.only(top: 10.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: const Color(0xFF141414),
                          border: Border.all(
                            color: isSelect ? const Color(0xFF7FF9F0) : Colors.transparent,
                            width: isSelect ? 2.0 : 0.0,
                          )),
                      child: Column(
                        children: [
                          SizedBox(height: 20.w),
                          CommText(
                            text: vp.remark2,
                            fontSize: 15.sp,
                            textColor: isSelect ? Colors.white : const Color(0x54FFFFFF),
                            fontWeight: FontWeight.w500,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: CommText(
                                    text: "¥",
                                    fontSize: 13.sp,
                                    textColor: isSelect ? const Color(0xFF7EF7F0) : const Color(0x54FFFFFF),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                CommText(
                                  text: vp.remark3 ?? "0",
                                  fontSize: 27.sp,
                                  textColor: isSelect ? const Color(0xFF7EF7F0) : const Color(0xff939393),
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.w),
                          CommText(
                            text: vp.remark4 ?? "",
                            fontSize: 12.sp,
                            textColor: const Color(0xff6F6F6F),
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !(vp.remark1 == "" || vp.remark1 == null),
                    child: Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                          height: 24.0,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(14.0),
                              bottomRight: Radius.circular(14),
                            ),
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFFF75), Color(0xFFFFC243)],
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(left: 8, right: 8),
                            child: Center(
                              child: CommText(
                                text: vp.remark1 ?? "",
                                fontSize: 12.sp,
                                textColor: const Color(0xff191919),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
