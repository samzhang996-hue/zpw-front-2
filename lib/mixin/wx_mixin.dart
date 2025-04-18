import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
import 'package:zpw/config/config.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

mixin WxMixin<T extends StatefulWidget> on State<T> {
  late Fluwx fluwx = Fluwx();
  Completer<String>? completer;
  void Wx() async {
    if (completer != null && !completer!.isCompleted) {
      completer = null;
    }
    EasyLoading.show(maskType: EasyLoadingMaskType.none, dismissOnTap: true);
    completer = Completer<String>();
    var isInstalled = await fluwx.isWeChatInstalled;
    EasyLoading.dismiss();
    if (!isInstalled) {
      HandleTool.showAppToastText('未安装微信');
      completer?.completeError('未安装微信');
      return;
    }

    fluwx
        .authBy(
            which: NormalAuth(
          scope: 'snsapi_userinfo',
          state: 'wechat_sdk_demo_test',
        ))
        .then((_) {})
        .catchError((e) {})
        .whenComplete(() {});
  }

  void _listenResp(WeChatResponse resp) {
    if (resp is WeChatAuthResponse) {
      // final String content = 'auth: ${resp.state} ${resp.errCode},${resp.code}';
      Log.e("msg,content:${resp.code}");

      if (resp.code == null) {
        HandleTool.showAppToastText('取消登录');
        completer?.completeError('');
        completer = null;
        return;
      }

      if (resp.errCode == -2) {
        HandleTool.showAppToastText('取消登录');
        completer?.completeError('');
        completer = null;
        return;
      }
      if (resp.errCode != 0) {
        HandleTool.showAppToastText('取消登录');
        completer?.completeError('');
        completer = null;
        return;
      }
      Log.e("msg,content----:${resp.code}");
      completer?.complete(resp.code);

      //   if (_mineController.wxNickName.isNotEmpty) {
      //     HandleTool.instance.SMWPost(Api.cancelWxBind, success: (isSuccess, code, message, results) {
      //       if (isSuccess && results.isNotEmpty) {
      //         HandleTool.instance.SMWPost(
      //           "${Api.bindWx}?code=${resp.code}",
      //           success: (isSuccess, code, message, results) async {
      //             if (isSuccess && results.isNotEmpty) {
      //               HandleTool.showAppToastText('换绑成功');
      //               _mineController.getUserInfo();
      //             }
      //             Log.e('--------------message:$results');
      //           },
      //         );
      //       } else {
      //         Log.e('message:$message');
      //       }
      //     });
      //   } else {
      // _loginWx(resp.code);

      ///
    }
  }

  void _initFluwx() async {
    await fluwx.registerApi(
      appId: Config.kWechatAppID,
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: Config.kWechatUniversalLink,
    );
  }

  @override
  void initState() {
    super.initState();
    _initFluwx();
    fluwx.clearSubscribers();
    fluwx.addSubscriber(_listenResp);
    // _respSubs = WechatKitPlatform.instance.respStream().listen(_listenLogin);
  }

  @override
  void dispose() {
    //
    super.dispose();
  }
}
