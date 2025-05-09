import 'package:get/get.dart';
import 'package:zpw/modules/main/model/user_info_bean.dart';

class MineState {
  late UserInfoBean userInfoBean;
  late RxList<dynamic> records;
  late String showImgGif;
  late String funcName;
  late RxInt index;
  MineState() {
    userInfoBean = UserInfoBean();
    records = [].obs;
    showImgGif = "";
    funcName = "";
    index = 1.obs;
  }
}
