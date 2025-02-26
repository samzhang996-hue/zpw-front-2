import 'package:get/get.dart';

class WorksState {
  late RxList<dynamic> records;
  late String showImgGif;
  late String funcName;
  late RxInt index;
  WorksState() {
    records = [].obs;
    showImgGif = "";
    funcName = "";
    index = 1.obs;
  }
}
