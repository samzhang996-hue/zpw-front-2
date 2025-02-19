import 'package:get/get.dart';
class Photo_listState {
  late int type;
  late RxBool isPermission;
  Photo_listState() {
    type=0;
    isPermission=false.obs;
  }
}
