import 'package:get/get.dart';
import 'package:zpw/modules/vip/model/payBean.dart';
import 'package:zpw/modules/vip/model/vipBean.dart';
class VipState {
  late int itemIndex;
  late RxBool isCheck;
  late PayBean payBean;
  late VipBean vipBean;
  VipState() {
    payBean = PayBean();
    vipBean = VipBean();
    isCheck=true.obs;
    itemIndex=0;

  }
}
