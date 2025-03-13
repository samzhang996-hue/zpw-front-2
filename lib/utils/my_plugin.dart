import 'dart:io';

import 'package:flutter/services.dart';

const methodChnnel = MethodChannel("MyPlugin");
// 事件通道
const EventChannel _eventChannel = const EventChannel('ads_event');

Future<String> getChannelInfo() async {
  return await methodChnnel.invokeMethod("getChannelInfo");
}

Future<String> getProjectId() async {
  return await methodChnnel.invokeMethod("projectId");
}

Future<String> getOAID() async {
  return await methodChnnel.invokeMethod("getOAID");
}

Future<String> getDeviceId() async {
  return await methodChnnel.invokeMethod("getDeviceId");
}

Future<String> onH5(String url) async {
  Map<String, dynamic> result = {'url': url};
  return await methodChnnel.invokeMethod("onH5", result);
}

Future<String> setOrderZfb(String url) async {
  Map<String, dynamic> result = {'message': url};
  return await methodChnnel.invokeMethod("setOrderZfb", result);
}

Future<void> startPhoto() async {
  return await methodChnnel.invokeMethod("startPhoto");
}

Future<void> rangerInit() async {
  if (Platform.isAndroid) {
    return await methodChnnel.invokeMethod("RangerInit");
  }
}

Future<bool> inpaint(
    String imagePath, String maskPath, String outputPath, int radius) async {
  try {
    final bool result = await methodChnnel.invokeMethod('inpaint', {
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

Future<String> getIDFA() async {
  try {
    final String idfa = await methodChnnel.invokeMethod('getIDFA');

    return idfa;
  } on PlatformException catch (_) {
    return "";
  }
}

Future<String> getIDFV() async {
  try {
    final String idfv = await methodChnnel.invokeMethod('getIDFV');

    return idfv;
  } on PlatformException catch (_) {
    return "";
  }
}
