import 'dart:async';
import 'dart:io';

import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';
import 'package:flutter_udid/flutter_udid.dart';
// import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/common/zpw_ads_config.dart';
import 'package:zpw/modules/main/main_page.dart';
import 'package:zpw/modules/main/model/user_info_bean.dart';
import 'package:zpw/modules/vip/vip_logic.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_ads_utils.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';
import 'package:zpw/utils/zpw_my_plugin.dart';
import 'package:zpw/utils/zpw_sp_utils.dart';

import 'splash_state.dart';

class SplashLogic extends ZpwBaseGetxController {
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
    ZpwHandleTool.instance.channel = channel;
    await ZpwSpUtils.setString("channel", channel);
    await ZpwSpUtils.setString("projectId", projectId);
    await ZpwHandleTool.instance.getProtocolConfig();
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
      String oaidStr = await ZpwSpUtils.getString("oaid");
      String deviceIdStr = await ZpwSpUtils.getString("deviceId");
      String channelStr = await ZpwSpUtils.getString("channel");
      oaid = oaidStr.isEmpty ? await getOAID() : oaidStr;
      deviceId = deviceIdStr.isEmpty ? await getDeviceId() : deviceIdStr;
      channel = channelStr.isEmpty ? await getChannelInfo() : channelStr;

      await ZpwSpUtils.setString("oaid", oaid);
      await ZpwSpUtils.setString("deviceId", deviceId);
      await ZpwSpUtils.setString("channel", channel);
    } else if (Platform.isIOS) {
      String deviceIdStr = await ZpwSpUtils.getString("deviceId");
      deviceId = deviceIdStr.isEmpty ? await FlutterUdid.udid : deviceIdStr;
      // deviceId = deviceIdStr.isEmpty ? "59245b9e42a7a51e1212" : deviceIdStr;
      ZpwSpUtils.setString("deviceId", deviceId);
      channel = "AIIOS";
    }
    ZpwHandleTool.instance.channel = channel;

    UmengCommonSdk.initCommon('', '67aeea638f232a05f113c1be', channel);
    UmengCommonSdk.setPageCollectionModeManual();
    ZpwLog.i('Device Info: $deviceId---$oaid----$channel-----${ZpwHandleTool.instance.channel}');
    _onLogin(channel, deviceId ?? "", oaid);
  }

  void _noTokenLogin() async {
    ////

    ////

    ////

    ////
    Get.put(VipLogic());

    if (ZpwHandleTool.instance.channelAds) {
      progress.value = 1.0;
      Get.offAll(const MainPage());
      return;
    }
    try {
      bool value = await ZpwAdsUtils.init().timeout(const Duration(seconds: 5));
      progress.value = 1.0;
      if (value) {
        ZpwAdsUtils.showSplashAd();
      } else {
        Get.offAll(const MainPage());
      }
    } on TimeoutException catch (_) {
      ZpwLog.e("ZpwAdsUtils.init() timed out");
      Get.offAll(const MainPage()); // 超时，直接进入主页
    } catch (error) {
      ZpwLog.e("ZpwAdsUtils.init() failed: $error");
      Get.offAll(const MainPage()); // 发生异常，直接进入主页
    }
    return;
  }

  Future<void> _tokenLogin() async {
    final result = await getAsync(ZpwApi.zpwAuthByToken);
    if (result.isSuccess && result.hasData) {
      requestMax = 100;
      Map data = result.first as Map;
      ZpwSpUtils.setString("token", data['token'] ?? "");
      ZpwHandleTool.instance.token = data['token'] ?? "";
      ZpwSpUtils.setBool("isAgreed", true);
      ZpwLog.d("res----${data}");
      Get.put(VipLogic());
      getUserInfo();
    }
  }

  loginWithDeviceInfo() async {
    final isAgreed = await ZpwSpUtils.getBool("isAgreed");
    if (isAgreed) {
      await ZpwHandleTool.instance.getProtocolConfig();
    }

    ZpwSpUtils.setBool("isAgreed", true);
    String token = await ZpwSpUtils.getString("token");
    ZpwHandleTool.instance.token = token;
    PackageInfo.fromPlatform().then((v) {
      ZpwHandleTool.instance.localVersion = v.version;
    });

    if (token.isEmpty) {
      rangerInit();
      _noTokenLogin();
    } else {
      _tokenLogin();
    }
    return;
    printDeviceInfo();
  }

  /// 处理网络权限问题
  handleNetWork() async {
    startRequestAction();
  }

  /// 执行请求任务
  startRequestAction() {
    ZpwHandleTool.instance.getProtocolConfig();
  }

  bool _showAd = true;

  _onLogin(String channel, String deviceId, String oaid, {bool isShowProgress = false}) async {
    String idfa = "";
    String idfv = "";
    if (Platform.isIOS) {
      idfa = await getIDFA();
      idfv = await getIDFV();
    }
    var androidID = '';
    if (Platform.isIOS) {
      androidID = deviceId;
    } else {
      androidID = await getAndroidID();
      if (androidID.isEmpty) {
        androidID = deviceId;
      }
    }
    Map<String, dynamic> dataMap = {
      "channel": channel,
      "userDeviceInfo": {"deviceCode": androidID, "systemDevice": Platform.isAndroid ? "android" : "ios", "oaid": oaid, "idfa": idfa, "idfv": idfv},
    };
    ZpwLog.i("requestMax====>${dataMap}");
    final result = await postAsync(ZpwApi.zpwSsoLogin, isShowProgress: isShowProgress, params: dataMap);
    requestMax = requestMax + 1;
    ZpwLog.i("isSuccess====>${result.isSuccess},requestMax:$requestMax,code:${result.code},message: ${result.message}");
    if (result.isSuccess && result.hasData) {
      requestMax = 100;
      Map data = result.first as Map;
      ZpwSpUtils.setString("token", data['token'] ?? "");
      ZpwHandleTool.instance.token = data['token'] ?? "";
      ZpwSpUtils.setBool("isAgreed", true);
      ZpwLog.d("res----${data}");
      Get.put(VipLogic());
      getUserInfo();
    } else {
      /// ------->  这里单独处理已选
      if (result.code == -1111) {
        if (requestMax > 30) {
          ///请求最大限制
          ZpwHandleTool.showAppToastText("请检查网络连接或者网络授权");
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            _onLogin(channel, deviceId, oaid, isShowProgress: false);
          });
        }
        return;
      }

      if (result.code == -2222) {
        _showAd = false;
        if (requestUserInfoMax > 30) {
          ///请求最大限制
          ZpwHandleTool.showAppToastText("请退出程序，稍后重试");
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            _onLogin(channel, deviceId, oaid, isShowProgress: false);
          });
        }
      }
    }
  }

  bool isFirst = false;

  getUserInfo() async {
    final result = await postAsync<UserInfoBean>(
      ZpwApi.zpwSsoGetUserInfo,
      isShowProgress: true,
      onModel: (m) => UserInfoBean.fromJson(m),
    );
    requestUserInfoMax = requestUserInfoMax + 1;
    ZpwLog.d("requestUserInfoMax----$requestUserInfoMax");
    if (result.isSuccess && result.hasData) {
      rangerInit();
      ZpwLog.d("requestUserInfoMax----$requestUserInfoMax，isSuccess: ${result.isSuccess}");
      requestUserInfoMax = 100;
      ZpwLog.d("userInfoBean----${result.first?.id}");
      UserInfoBean userInfoBean = result.first!;
      ZpwHandleTool.instance.isMember = userInfoBean.vipFlag == 1;
      ZpwLog.d("userInfoBean----${ZpwHandleTool.instance.isMember},userInfoBean.nickName----${userInfoBean.nickName}");
      UmengCommonSdk.onProfileSignIn("${userInfoBean.nickName}");
      // Get.offAll(const MainPage());
      // return;
      if (userInfoBean.headImg!.isNotEmpty) {
        isFirst = true;
      }
      ZpwHandleTool.instance.headImg = userInfoBean.headImg ?? '';
      if (!_showAd || ZpwHandleTool.instance.channelAds) {
        progress.value = 1.0;
        Get.offAll(const MainPage());
        return;
      }
      try {
        bool value = await ZpwAdsUtils.init().timeout(Duration(seconds: 5));
        ZpwLog.d("ads2----$value");
        progress.value = 1.0;
        if (value) {
          ZpwAdsUtils.showSplashAd();
        } else {
          Get.offAll(const MainPage());
        }
      } on TimeoutException catch (_) {
        ZpwLog.e("ZpwAdsUtils.init() timed out");
        Get.offAll(const MainPage()); // 超时，直接进入主页
      } catch (error) {
        ZpwLog.e("ZpwAdsUtils.init() failed: $error");
        Get.offAll(const MainPage()); // 发生异常，直接进入主页
      }
    } else {
      if (result.code == -2222) {
        _showAd = false;
        if (requestUserInfoMax > 30) {
          ///请求最大限制
          ZpwHandleTool.showAppToastText("请退出程序，稍后重试");
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            getUserInfo();
          });
        }
      }
    }
  }

  test() {
    FlutterPangleAds.onEventListener((event) {
      if (event.adId == ZpwAdsConfig.zpwSplashId) {
        if (event.action == AdEventAction.onAdError || event.action == AdEventAction.onAdLoaded) {
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
