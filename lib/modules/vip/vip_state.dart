import 'package:get/get.dart';
import 'package:zpw/modules/vip/model/payBean.dart';
import 'package:zpw/modules/vip/model/vipBean.dart';
class VipState {
  late int itemIndex;
  late RxBool isCheck;
  late PayBean payBean;
  late VipBean vipBean;
  late int payKeyType;
  late int goodsId;
  late int isWx;
  late int isZfb;
  VipState() {
    payBean = PayBean();
    vipBean = VipBean();
    isCheck=true.obs;
    itemIndex=0;
    payKeyType=0;
    goodsId=0;
    isWx=0;
    isZfb=0;

  }
}
