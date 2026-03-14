import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
import 'package:zpw/config/zpw_config.dart';
import 'package:zpw/utils/zpw_handle_tool.dart';
import 'package:zpw/utils/zpw_log_utils.dart';

mixin ZpwWxMixin<T extends StatefulWidget> on State<T> {
  late Fluwx zpwFluwx = Fluwx();
  Completer<String>? zpwCompleter;
  void zpwWx() async {
    if (zpwCompleter != null && !zpwCompleter!.isCompleted) {
      zpwCompleter = null;
    }
    EasyLoading.show(maskType: EasyLoadingMaskType.none, dismissOnTap: true);
    zpwCompleter = Completer<String>();
    var zpwIsInstalled = await zpwFluwx.isWeChatInstalled;
    EasyLoading.dismiss();
    if (!zpwIsInstalled) {
      ZpwHandleTool.showAppToastText('未安装微信');
      zpwCompleter?.completeError('未安装微信');
      return;
    }

    zpwFluwx
        .authBy(
            which: NormalAuth(
          scope: 'snsapi_userinfo',
          state: 'wechat_sdk_demo_test',
        ))
        .then((_) {})
        .catchError((e) {})
        .whenComplete(() {});
  }

  void _zpwListenResp(WeChatResponse resp) {
    if (resp is WeChatAuthResponse) {
      // final String content = 'auth: ${resp.state} ${resp.errCode},${resp.code}';
      ZpwLog.e("msg,content:${resp.code}");

      if (resp.code == null) {
        ZpwHandleTool.showAppToastText('取消登录');
        zpwCompleter?.completeError('');
        zpwCompleter = null;
        return;
      }

      if (resp.errCode == -2) {
        ZpwHandleTool.showAppToastText('取消登录');
        zpwCompleter?.completeError('');
        zpwCompleter = null;
        return;
      }
      if (resp.errCode != 0) {
        ZpwHandleTool.showAppToastText('取消登录');
        zpwCompleter?.completeError('');
        zpwCompleter = null;
        return;
      }
      ZpwLog.e("msg,content----:${resp.code}");
      zpwCompleter?.complete(resp.code);

      //   if (_mineController.wxNickName.isNotEmpty) {
      //     ZpwHandleTool.instance.SMWPost(Api.cancelWxBind, success: (isSuccess, code, message, results) {
      //       if (isSuccess && results.isNotEmpty) {
      //         ZpwHandleTool.instance.SMWPost(
      //           "${Api.bindWx}?code=${resp.code}",
      //           success: (isSuccess, code, message, results) async {
      //             if (isSuccess && results.isNotEmpty) {
      //               ZpwHandleTool.showAppToastText('换绑成功');
      //               _mineController.getUserInfo();
      //             }
      //             ZpwLog.e('--------------message:$results');
      //           },
      //         );
      //       } else {
      //         ZpwLog.e('message:$message');
      //       }
      //     });
      //   } else {
      // _loginWx(resp.code);

      ///
    }
  }

  void _zpwInitFluwx() async {
    await zpwFluwx.registerApi(
      appId: ZpwConfig.kWechatAppID,
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: ZpwConfig.kWechatUniversalLink,
    );
  }

  @override
  void initState() {
    super.initState();
    _zpwInitFluwx();
    zpwFluwx.clearSubscribers();
    zpwFluwx.addSubscriber(_zpwListenResp);
    // _respSubs = WechatKitPlatform.instance.respStream().listen(_listenLogin);
  }

  @override
  void dispose() {
    //
    super.dispose();
  }
}