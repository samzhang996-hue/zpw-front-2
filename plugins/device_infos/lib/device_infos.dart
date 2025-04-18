import 'package:flutter/services.dart';

abstract class DeviceInfos {
  static const _methodChannel = MethodChannel('com.muka.device_infos');

  static Future<String> getDeviceId() async {
    return await _methodChannel.invokeMethod('getDeviceId');
  }

  static Future<String> getAndroidID() async {
    return await _methodChannel.invokeMethod('getAndroidID');
  }

  static Future<String> getIMEI() async {
    return await _methodChannel.invokeMethod('getIMEI');
  }

  static Future<String> getMEID() async {
    return await _methodChannel.invokeMethod('getMEID');
  }

  static Future<String> getPageData() async {
    return await _methodChannel.invokeMethod('getPageData');
  }

  static Future<String> getOAID() async {
    return await _methodChannel.invokeMethod('getOAID');
  }

  static Future<String> getUA() async {
    return await _methodChannel.invokeMethod('getUA');
  }

  static Future<String> getChannel() async {
    return await _methodChannel.invokeMethod('getChannel');
  }

  static Future<String?> getIDFV() async {
    return await _methodChannel.invokeMethod('getIDFV');
  }

  static Future<String?> getIDFA() async {
    return await _methodChannel.invokeMethod('getIDFA');
  }

  static Future<String> getProjectId() async {
    return await _methodChannel.invokeMethod('projectId');
  }

  static Future<String> setOrderZfb(String url) async {
    Map<String, dynamic> result = {'message': url};
    return await _methodChannel.invokeMethod('setOrderZfb', result);
  }

  static Future<String> getChannelInfo(int type) async {
    Map<String, dynamic> result = {'type': type};
    return await _methodChannel.invokeMethod('getChannelInfo', result);
  }

  static Future<String> onDownloadFile(String url) async {
    Map<String, dynamic> result = {'url': url};
    return await _methodChannel.invokeMethod('onDownloadFile', result);
  }

  static Future<void> onBlood() async {
    return await _methodChannel.invokeMethod('onBlood');
  }

  static Future<String> htmlFlutter(String appId, String jumpUrl, String outTradeNo) async {
    Map<String, dynamic> result = {
      'appId': appId,
      'jumpUrl': jumpUrl,
      'outTradeNo': outTradeNo,
    };
    return await _methodChannel.invokeMethod('htmlFlutter', result);
  }

  static Future<String> xcsFlutter(int userId, int goodsId) async {
    Map<String, dynamic> result = {'userId': userId, 'goodsId': goodsId};
    return await _methodChannel.invokeMethod('xcsFlutter', result);
  }

  static Future<String> onH5(String url) async {
    Map<String, dynamic> result = {'url': url};
    return await _methodChannel.invokeMethod("onH5", result);
  }

  /// 获取运营商
  static Future<String> getOperator() async {
    return await _methodChannel.invokeMethod('getOperator');
  }

  /// 获取运营商
  static Future<String> aliAuthInit(String key) async {
    return await _methodChannel.invokeMethod('aliAuthInit', {'keySecret': key});
  }
}
