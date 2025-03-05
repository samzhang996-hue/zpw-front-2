import 'package:flutter/services.dart';
import 'package:zpw/utils/log_utils.dart';

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

Future<bool> inpaint(String imagePath, String maskPath, String outputPath, int radius) async {
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
