import 'package:get/get.dart';

class ZpwAboutState {
  late RxString size;
  late RxString version;
  late RxString channel;
  ZpwAboutState() {
    size = "0.0M".obs;
    version = "".obs;
    channel = "".obs;
  }
}
