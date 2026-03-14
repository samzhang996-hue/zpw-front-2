import 'package:get/get.dart';

class ZpwMakewstState {
  late RxList<dynamic> records;
  late RxList<Map<String, dynamic>> hfList;
  late RxString funcValue;
  late RxString title;
  late RxString name;
  late RxInt funcId;
  late List<Map<String, dynamic>> itemTitles;
  late RxInt titleIndex;
  late RxInt fgIndex;
  late RxBool isAdd;

  ZpwMakewstState() {
    records = [].obs;
    hfList = <Map<String, dynamic>>[].obs;
    funcId = 0.obs;
    titleIndex = 0.obs;
    fgIndex = 0.obs;
    isAdd = false.obs;
    funcValue = "".obs;
    title = "1:1".obs;
    name = "无风格".obs;
    itemTitles = [
      {
        'title': "1:1",
        "width": "1080",
        "height": "1080",
      },
      {
        "title": "16:9",
        "width": "1920",
        "height": "1080",
      },
      {
        'title': "9:16",
        "width": "1080",
        "height": "1920",
      },
      {
        'title': "4:3",
        "width": "1280",
        "height": "960",
      },
      {
        'title': "3:4",
        "width": "960",
        "height": "1280",
      }
    ];
  }
}
