import 'package:get/get.dart';

class WorksState {
  late List<dynamic> records;
  late String showImgGif;
  late String funcName;
  late RxInt index;

  WorksState() {
    records = [];
    showImgGif = "";
    funcName = "";
    index = 1.obs;
  }
}
