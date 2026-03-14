import 'package:get/get.dart';

class SettingState {
  late RxString version;
  late RxString channel;
  SettingState() {
    version = "".obs;
    channel = "".obs;
  }
}
