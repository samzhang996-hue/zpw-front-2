import 'package:get/get.dart';

class AboutState {
  late RxString size;
  late RxString version;
  late RxString channel;
  AboutState() {
    size = "0.0M".obs;
    version = "".obs;
    channel = "".obs;
  }
}
