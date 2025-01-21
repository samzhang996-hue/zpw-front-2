import 'package:get/get.dart';
class DetailState {

  late RxInt worksType;
  late RxString returnUrl;
  DetailState() {
    worksType=0.obs;
    returnUrl="".obs;
  }
}
