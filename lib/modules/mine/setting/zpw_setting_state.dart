import 'package:get/get.dart';

class ZpwSettingState {
  late RxString version;
  late RxString channel;
  ZpwSettingState() {
    version = "".obs;
    channel = "".obs;
  }
}
