import 'package:flutter/services.dart';
import 'package:zpw/utils/log_utils.dart';

const methodChnnel = MethodChannel("MyPlugin");
// 事件通道
const EventChannel _eventChannel = const EventChannel('ads_event');

Future<String> getChannelInfo(int type) async {
  Map<String, dynamic> result = {'type': type};
  return await methodChnnel.invokeMethod("getChannelInfo", result);
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