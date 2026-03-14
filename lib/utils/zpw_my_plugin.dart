import 'dart:io';

import 'package:flutter/services.dart';

const zpwMethodChannel = MethodChannel("zpw_plugin");
// 事件通道
const EventChannel _zpwEventChannel = const EventChannel('zpw_ads_event');

Future<String> getChannelInfo() async {
  return await zpwMethodChannel.invokeMethod("getChannelInfo");
}

Future<String> getProjectId() async {
  return await zpwMethodChannel.invokeMethod("projectId");
}

Future<String> getOAID() async {
  return await zpwMethodChannel.invokeMethod("getOAID");
}

Future<String> getDeviceId() async {
  return await zpwMethodChannel.invokeMethod("getDeviceId");
}

Future<String> onH5(String url) async {
  Map<String, dynamic> result = {'url': url};
  return await zpwMethodChannel.invokeMethod("onH5", result);
}

Future<String> setOrderZfb(String url) async {
  Map<String, dynamic> result = {'message': url};
  return await zpwMethodChannel.invokeMethod("setOrderZfb", result);
}

Future<void> startPhoto() async {
  return await zpwMethodChannel.invokeMethod("startPhoto");
}

Future<void> rangerInit() async {
  if (Platform.isAndroid) {
    return await zpwMethodChannel.invokeMethod("RangerInit");
  }
}

Future<bool> zpwInpaint(String imagePath, String maskPath, String outputPath, int radius) async {
  try {
    final bool result = await zpwMethodChannel.invokeMethod('inpaint', {
      'imagePath': imagePath,
      'maskPath': maskPath,
      'outputPath': outputPath,
      'radius': radius,
    });
    return result;
  } on PlatformException catch (e) {
    print("Failed to inpaint: '${e.message}'.");
    return false;
  }
}

// 兼容旧函数名
Future<bool> inpaint(String imagePath, String maskPath, String outputPath, int radius) =>
    zpwInpaint(imagePath, maskPath, outputPath, radius);

Future<String> getIDFA() async {
  try {
    final String idfa = await zpwMethodChannel.invokeMethod('getIDFA');

    return idfa;
  } on PlatformException catch (_) {
    return "";
  }
}

Future<String> getIDFV() async {
  try {
    final String idfv = await zpwMethodChannel.invokeMethod('getIDFV');

    return idfv;
  } on PlatformException catch (_) {
    return "";
  }
}

Future<String> getUA() async {
  try {
    final String ua = await zpwMethodChannel.invokeMethod('getUA');

    return ua;
  } on PlatformException catch (_) {
    return "";
  }
}

Future<String> getAndroidID() async {
  try {
    final String androidID = await zpwMethodChannel.invokeMethod('getAndroidID');
    return androidID;
  } on PlatformException catch (_) {
    return "";
  }
}