import 'package:get/get.dart';
class ZpwPhotoListState {
  late int type;
  late RxBool isPermission;
  ZpwPhotoListState() {
    type=0;
    isPermission=false.obs;
  }
}
