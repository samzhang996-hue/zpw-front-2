import 'package:get/get.dart';
class DetailState {

  late RxInt worksType;
  late RxInt id;
  late RxInt funcId;
  late RxInt apiType;
  late RxString returnUrl;
  late RxString tags;
  DetailState() {
    worksType=0.obs;
    id=0.obs;
    funcId=0.obs;
    apiType=0.obs;
    returnUrl="".obs;
    tags="".obs;
  }
}
