import 'dart:io';

import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/ads_utils.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';
import 'package:zpw/utils/my_plugin.dart';
import 'package:zpw/utils/sp_utils.dart';

import 'model/login_entity.dart';
import 'splash_state.dart';

class SplashLogic extends BaseGetxController {
  final SplashState state = SplashState();

  bool requestFinlish = true;
  int requestMax = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    HandleTool.instance.getProtocolConfig();
    // handleNetWork();
  }

  void printDeviceInfo() async {
    String? deviceId;
    String channel = "android";
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
      // IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // deviceId = iosInfo.identifierForVendor;
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
        "deviceId": deviceId,
        "systemDevice": Platform.isAndroid ? "android" : "ios",
        "oaid": oaid,
        "idfa": udid
      },
    };
    requestFinlish = false;
    Post<LoginEntity>(Api.sso_login,
        isShowProgress: isShowProgress,
        params: dataMap,
        success: (isSuccess, code, message, results) async {
          requestFinlish = true;
          requestMax = requestMax + 1;
          Log.i("requestMax====>${requestMax}");
          if (isSuccess == true && results.isNotEmpty) {
            requestMax = 100;
            final loginEntity = results[0];
            HandleTool.instance.isMember = loginEntity.isMember ?? false;
            HandleTool.instance.isSignTask = loginEntity.isSignTask ?? false;
            Log.d(
                "login--${loginEntity.authToken}--${HandleTool.instance.isMember}");
            SpUtils.setString("token", loginEntity.authToken ?? "");
            SpUtils.setBool("isAgreed", true);

            AdsUtils.init().then((value) {
              if (value) {
                AdsUtils.showSplashAd();
              }
            });
          } else {
            /// ------->  这里单独处理已选
            if (code == -1111) {
              if (requestMax > 30) {
                ///请求最大限制
                HandleTool.showAppToastText("请检查网络连接或者网络授权");
              } else {
                Future.delayed(Duration(seconds: 1), () {
                  _onLogin(channel, deviceId, oaid, isShowProgress: false);
                });
              }
            }
          }
        },
        onModel: (m) => LoginEntity.fromJson(m));
  }
}
