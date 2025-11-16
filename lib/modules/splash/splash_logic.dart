import 'dart:async';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';
import 'package:flutter_udid/flutter_udid.dart';
// import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/common/ads_config.dart';
import 'package:zpw/modules/main/main_page.dart';
import 'package:zpw/modules/main/model/user_info_bean.dart';
import 'package:zpw/modules/vip/vip_logic.dart';
import 'package:zpw/network/api_config.dart';
import 'package:zpw/network/http_client.dart';
import 'package:zpw/utils/ads_utils.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:zpw/utils/my_plugin.dart';
import 'package:zpw/utils/sp_utils.dart';

import '../../controller/config_by_key_controller.dart';
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
    HandleTool.instance.channel = channel;
    await SpUtils.setString("channel", channel);
    await SpUtils.setString("projectId", projectId);
    await HandleTool.instance.getProtocolConfig();
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
      channel = "DNXJIOS";
    }
    HandleTool.instance.channel = channel;

    UmengCommonSdk.initCommon('', '67aeea638f232a05f113c1be', channel);
    UmengCommonSdk.setPageCollectionModeManual();
    _onLogin(channel, deviceId ?? "", oaid);
  }

  void _noTokenLogin() async {
    ////

    ////

    ////

    ////
    Get.put(VipLogic());

    if (HandleTool.instance.channelAds) {
      progress.value = 1.0;
      Get.offAll(const MainPage());
      return;
    }
    try {
      bool value = await AdsUtils.init().timeout(const Duration(seconds: 5));
      progress.value = 1.0;
      if (value) {
        AdsUtils.showSplashAd();
      } else {
        Get.offAll(const MainPage());
      }
    } on TimeoutException catch (_) {
      Get.offAll(const MainPage()); // 超时，直接进入主页
    } catch (error) {
      Get.offAll(const MainPage()); // 发生异常，直接进入主页
    }
    return;
  }

  Future<void> _tokenLogin() async {
    try {
      final response = await HttpClient().get(
        ApiConfig.authByToken,
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        if (dataList.isNotEmpty) {
          requestMax = 100;
          Map data = dataList.first as Map;
          SpUtils.setString("token", data['token'] ?? "");
          HandleTool.instance.token = data['token'] ?? "";
          SpUtils.setBool("isAgreed", true);
          Get.put(VipLogic());
          getUserInfo();
        }
      } else {
        EasyLoading.showError(response.message);
      }
    } catch (e) {
      EasyLoading.showError('请求失败: $e');
    }
  }

  loginWithDeviceInfo() async {
    if (Platform.isIOS) {
      progress.value = 0.5;
      await HandleTool.instance.getProtocolConfig();
      progress.value = 1.0;
    }
    final c = Get.put(ConfigByKeyController());
    c.getConfigByKey();
    final isAgreed = await SpUtils.getBool("isAgreed");
    if (isAgreed) {
      await HandleTool.instance.getProtocolConfig();
    }

    SpUtils.setBool("isAgreed", true);
    String token = await SpUtils.getString("token");
    HandleTool.instance.token = token;
    PackageInfo.fromPlatform().then((v) {
      HandleTool.instance.localVersion = v.version;
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
    // HandleTool.instance.getProtocolConfig();
  }

  bool _showAd = true;

  Future<void> _onLogin(String channel, String deviceId, String oaid, {bool isShowProgress = false}) async {
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

    try {
      final response = await HttpClient().post(
        ApiConfig.sso_login,
        data: dataMap,
        showLoading: isShowProgress,
      );

      requestMax = requestMax + 1;

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        if (dataList.isNotEmpty) {
          requestMax = 100;
          Map data = dataList.first as Map;
          SpUtils.setString("token", data['token'] ?? "");
          HandleTool.instance.token = data['token'] ?? "";
          SpUtils.setBool("isAgreed", true);
          Get.put(VipLogic());
          getUserInfo();
        }
      } else {
        /// ------->  这里单独处理已选
        if (response.code == -1111) {
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

        if (response.code == -2222) {
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
    } catch (e) {
      requestMax = requestMax + 1;
      if (requestMax <= 30) {
        Future.delayed(const Duration(seconds: 1), () {
          _onLogin(channel, deviceId, oaid, isShowProgress: false);
        });
      } else {
        HandleTool.showAppToastText("请检查网络连接或者网络授权");
      }
    }
  }

  bool isFirst = false;

  Future<void> getUserInfo() async {
    try {
      final response = await HttpClient().post(
        ApiConfig.sso_getUserInfo,
        showLoading: true,
      );

      requestUserInfoMax = requestUserInfoMax + 1;

      if (response.isSuccess && response.data != null) {
        final List<dynamic> dataList = response.data as List<dynamic>;
        final results = dataList
            .map((e) => UserInfoBean.fromJson(e as Map<String, dynamic>))
            .toList();

        if (results.isNotEmpty) {
          rangerInit();
          requestUserInfoMax = 100;
          UserInfoBean userInfoBean = results.first;
          HandleTool.instance.isMember = userInfoBean.vipFlag == 1;
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
            progress.value = 1.0;
            if (value) {
              AdsUtils.showSplashAd();
            } else {
              Get.offAll(const MainPage());
            }
          } on TimeoutException catch (_) {
            Get.offAll(const MainPage()); // 超时，直接进入主页
          } catch (error) {
            Get.offAll(const MainPage()); // 发生异常，直接进入主页
          }
        }
      } else {
        if (response.code == -2222) {
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
    } catch (e) {
      requestUserInfoMax = requestUserInfoMax + 1;
      if (requestUserInfoMax <= 30) {
        Future.delayed(const Duration(seconds: 1), () {
          getUserInfo();
        });
      } else {
        HandleTool.showAppToastText("请退出程序，稍后重试");
      }
    }
  }

  test() {
    FlutterPangleAds.onEventListener((event) {
      if (event.adId == AdsConfig.splashId) {
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
