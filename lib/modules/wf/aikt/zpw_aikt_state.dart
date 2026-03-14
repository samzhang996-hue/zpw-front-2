import 'package:get/get.dart';
class ZpwAiktState {
  late RxString path;
  late RxString text;
  late RxDouble outPaintRatio;
  ZpwAiktState() {
    path="".obs;
    text="开始扩图".obs;
    outPaintRatio=0.1.obs;
  }
}
