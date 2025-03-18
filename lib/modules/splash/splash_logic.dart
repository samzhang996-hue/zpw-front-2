import 'dart:async';
import 'dart:io';

import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';
import 'package:flutter_udid/flutter_udid.dart';
// import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/common/ads_config.dart';
import 'package:zpw/modules/main/main_page.dart';
import 'package:zpw/modules/main/model/user_info_bean.dart';
import 'package:zpw/modules/vip/vip_logic.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/ads_utils.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:zpw/utils/my_plugin.dart';
import 'package:zpw/utils/sp_utils.dart';

import 'splash_state.dart';

class SplashLogic extends BaseGetxController {
  RxDouble progress = 0.0.obs;
  Timer? _timer;
  final SplashState state = SplashState();
  int requestMax = 0;
  int requestUserInfoMax = 0;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    String projectId = await getProjectId();
    String channel = await getChannelInfo();
    await SpUtils.setString("channel", channel);
    await SpUtils.setString("projectId", projectId);
    HandleTool.instance.getProtocolConfig();
    // handleNetWork();
    test();
    startProgress();
  }

  void startProgress() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (progress.value < 0.9) {
        progress.value += 0.01;
      }
    });
  }

  void stopPolling() {
    _timer?.cancel();
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
      channel = channelStr.isEmpty ? await getChannelInfo() : channelStr;

      await SpUtils.setString("oaid", oaid);
      await SpUtils.setString("deviceId", deviceId);
      await SpUtils.setString("channel", channel);
    } else if (Platform.isIOS) {
      String deviceIdStr = await SpUtils.getString("deviceId");
      deviceId = deviceIdStr.isEmpty ? await FlutterUdid.udid : deviceIdStr;
      // deviceId = deviceIdStr.isEmpty ? "59245b9e42a7a51e1212" : deviceIdStr;
      SpUtils.setString("deviceId", deviceId);
      channel = "AIIOS";
    }
    HandleTool.instance.channel = channel;

    UmengCommonSdk.initCommon('', '67aeea638f232a05f113c1be', channel);
    UmengCommonSdk.setPageCollectionModeManual();
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

  bool _showAd = true;

  _onLogin(String channel, String deviceId, String oaid,
      {bool isShowProgress = false}) async {
    String idfa = "";
    String idfv = "";
    if (Platform.isIOS) {
      idfa = await getIDFA();
      idfv = await getIDFV();
    }
    var androidID = '';
    if (Platform.isIOS) {
      androidID = deviceId;
    }else {
      androidID = await getAndroidID();
      if(androidID.isEmpty){
        androidID = deviceId;
      }
    }
    Map<String, dynamic> dataMap = {
      "channel": channel,
      "userDeviceInfo": {
        "deviceCode": deviceId,
        "systemDevice": Platform.isAndroid ? "android" : "ios",
        "oaid": oaid,
        "idfa": idfa,
        "idfv": idfv
      },
    };
    Log.i("requestMax====>${dataMap}");
    Post(Api.sso_login, isShowProgress: isShowProgress, params: dataMap,
        success: (isSuccess, code, message, results) async {
      requestMax = requestMax + 1;
      Log.i(
          "isSuccess====>${isSuccess},requestMax:$requestMax,code:$code,message: $message");
      if (isSuccess == true && results.isNotEmpty) {
        requestMax = 100;
        Map data = results.first as Map;
        SpUtils.setString("token", data['token'] ?? "");
        SpUtils.setBool("isAgreed", true);
        Log.d("res----${data}");
        Get.put(VipLogic());
        getUserInfo();
      } else {
        /// ------->  这里单独处理已选
        if (code == -1111) {
          if (requestMax > 30) {
            ///请求最大限制
            HandleTool.showAppToastText("请检查网络连接或者网络授权");
          } else {
            Future.delayed(const Duration(seconds: 1), () {
              _onLogin(channel, deviceId, oaid, isShowProgress: false);
            });
          }
          return;
        }

        if (code == -2222) {
          _showAd = false;
          if (requestUserInfoMax > 30) {
            ///请求最大限制
            HandleTool.showAppToastText("请退出程序，稍后重试");
          } else {
            Future.delayed(const Duration(seconds: 1), () {
              _onLogin(channel, deviceId, oaid, isShowProgress: false);
            });
          }
        }
      }
    });
  }

  bool isFirst = false;

  getUserInfo() {
    Post<UserInfoBean>(Api.sso_getUserInfo,
        isShowProgress: true,
        success: (isSuccess, code, message, results) async {
          requestUserInfoMax = requestUserInfoMax + 1;
          Log.d("requestUserInfoMax----$requestUserInfoMax");
          if (isSuccess == true && results.isNotEmpty) {
            rangerInit();
            Log.d(
                "requestUserInfoMax----$requestUserInfoMax，isSuccess: $isSuccess");
            requestUserInfoMax = 100;
            Log.d("userInfoBean----${results.first.id}");
            UserInfoBean userInfoBean = results.first;
            HandleTool.instance.isMember = userInfoBean.vipFlag == 1;
            Log.d(
                "userInfoBean----${HandleTool.instance.isMember},userInfoBean.nickName----${userInfoBean.nickName}");
            UmengCommonSdk.onProfileSignIn("${userInfoBean.nickName}");
            // Get.offAll(const MainPage());
            // return;
            if (userInfoBean.headImg!.isNotEmpty) {
              isFirst = true;
            }
            HandleTool.instance.headImg = userInfoBean.headImg ?? '';
            if (!_showAd || HandleTool.instance.channelAds) {
              progress.value = 1.0;
              Get.offAll(const MainPage());
              return;
            }
            try {
              bool value = await AdsUtils.init().timeout(Duration(seconds: 5));
              Log.d("ads2----$value");
              progress.value = 1.0;
              if (value) {
                AdsUtils.showSplashAd();
              } else {
                Get.offAll(const MainPage());
              }
            } on TimeoutException catch (_) {
              Log.e("AdsUtils.init() timed out");
              Get.offAll(const MainPage()); // 超时，直接进入主页
            } catch (error) {
              Log.e("AdsUtils.init() failed: $error");
              Get.offAll(const MainPage()); // 发生异常，直接进入主页
            }


          } else {
            if (code == -2222) {
              _showAd = false;
              if (requestUserInfoMax > 30) {
                ///请求最大限制
                HandleTool.showAppToastText("请退出程序，稍后重试");
              } else {
                Future.delayed(const Duration(seconds: 1), () {
                  getUserInfo();
                });
              }
            }
          }
        },
        onModel: (m) => UserInfoBean.fromJson(m));
  }

  test() {
    FlutterPangleAds.onEventListener((event) {
      if (event.adId == AdsConfig.splashId) {
        if (event.action == AdEventAction.onAdError ||
            event.action == AdEventAction.onAdLoaded) {
          // if (isFirst) {
          Get.offAll(const MainPage());
          // } else {
          //   // Get.offAll(const MainPage());
          //   // return;
          //   Get.offAll(GuidePage());
          // }
        }
      }
    });
  }
}
