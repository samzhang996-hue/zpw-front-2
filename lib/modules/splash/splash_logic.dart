import 'dart:io';

import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/common/ads_config.dart';
import 'package:zpw/modules/main/main_page.dart';
import 'package:zpw/modules/main/model/user_info_bean.dart';
import 'package:zpw/modules/splash/guide/guide_view.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:zpw/utils/my_plugin.dart';
import 'package:zpw/utils/sp_utils.dart';

import 'splash_state.dart';

class SplashLogic extends BaseGetxController {
  final SplashState state = SplashState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    HandleTool.instance.getProtocolConfig();
    // handleNetWork();
    test();
  }

  void printDeviceInfo() async {
    String? deviceId;
    String channel = "AIJL300";
    String oaid = "";
    if (Platform.isAndroid) {
      String oaidStr = await SpUtils.getString("oaid");
      String deviceIdStr = await SpUtils.getString("deviceId");
      String channelStr = await SpUtils.getString("channel");
      oaid = oaidStr.isEmpty ? await getOAID() : oaidStr;
      deviceId = deviceIdStr.isEmpty ? await getDeviceId() : deviceIdStr;
      channel = channelStr.isEmpty ? await getChannelInfo(3) : channelStr;

      await SpUtils.setString("oaid", oaid);
      await SpUtils.setString("deviceId", deviceId);
      await SpUtils.setString("channel", channel);
    } else if (Platform.isIOS) {
      channel = "ios";
    }
    HandleTool.instance.channel = channel;
    Log.i(
        'Device Info: $deviceId---$oaid----$channel-----${HandleTool.instance.channel}');
    _onLogin(channel, deviceId ?? "", oaid);
  }

  loginWithDeviceInfo() async {
    Log.i('Device channel: ----123');
    printDeviceInfo();
  }

  /// 处理网络权限问题
  handleNetWork() async {
    startRequestAction();
  }

  /// 执行请求任务
  startRequestAction() {
    HandleTool.instance.getProtocolConfig();
  }

  _onLogin(String channel, String deviceId, String oaid,
      {bool isShowProgress = true}) async {
    String udid = "";
    if (Platform.isIOS) {
      udid = "ios唯一标识";
    }
    Map<String, dynamic> dataMap = {
      "channel": channel,
      "userDeviceInfo": {
        "deviceCode": deviceId,
        "systemDevice": Platform.isAndroid ? "android" : "ios",
        "oaid": oaid,
        "idfa": udid
      },
    };
    Log.i("requestMax====>${dataMap}");
    Post(Api.sso_login, isShowProgress: isShowProgress, params: dataMap,
        success: (isSuccess, code, message, results) async {
      if (isSuccess == true && results.isNotEmpty) {
        Map data = results.first as Map;
        SpUtils.setString("token", data['token'] ?? "");
        SpUtils.setBool("isAgreed", true);
        Log.d("res----${data}");
        getUserInfo();
      }
    });
  }

  bool isFirst = false;

  getUserInfo() {
    Post<UserInfoBean>(Api.sso_getUserInfo,
        isShowProgress: true,
        success: (isSuccess, code, message, results) {
          if (isSuccess == true && results.isNotEmpty) {
            Log.d("userInfoBean----${results.first.id}");
            UserInfoBean userInfoBean = results.first;
            HandleTool.instance.isMember = userInfoBean.isMember ?? false;
            if (userInfoBean.headImg!.isNotEmpty) {
              isFirst = true;
            }

            Get.offAll(GuidePage());

            // AdsUtils.init().then((value) {
            //   if (value) {
            //     AdsUtils.showSplashAd();
            //   }
            // });
          }
        },
        onModel: (m) => UserInfoBean.fromJson(m));
  }

  test() {
    FlutterPangleAds.onEventListener((event) {
      if (event.adId == AdsConfig.splashId) {
        if (event.action == AdEventAction.onAdError ||
            event.action == AdEventAction.onAdLoaded) {
          if (isFirst) {
            Get.offAll(const MainPage());
          } else {
            Get.offAll(GuidePage());
          }
        }
      }
    });
  }
}
