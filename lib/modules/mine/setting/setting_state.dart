import 'package:get/get.dart';
class SettingState {
 late RxString version;
 late RxString size;
  SettingState() {
    version="".obs;
    size="0.0M".obs;
  }
}
