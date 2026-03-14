import 'package:get/get.dart';
class AiktState {
  late RxString path;
  late RxString text;
  late RxDouble outPaintRatio;
  AiktState() {
    path="".obs;
    text="开始扩图".obs;
    outPaintRatio=0.1.obs;
  }
}
