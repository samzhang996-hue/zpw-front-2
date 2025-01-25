import 'package:get/get.dart';
class SettingState {
 late RxString version;
 late RxString size;
 late RxString channel;
  SettingState() {
    version="".obs;
    size="0.0M".obs;
    channel="".obs;
  }
}
