import 'package:get/get.dart';

class ZpwWorksState {
  late RxList<dynamic> records;
  late String showImgGif;
  late String funcName;
  late RxInt index;
  ZpwWorksState() {
    records = [].obs;
    showImgGif = "";
    funcName = "";
    index = 1.obs;
  }
}
