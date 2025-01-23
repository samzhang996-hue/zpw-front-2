import 'package:get/get.dart';
import 'package:zpw/modules/vip/model/payBean.dart';
import 'package:zpw/modules/vip/model/vipBean.dart';
class VipState {
  late int itemIndex;
  late int type;
  late RxBool isCheck;
  late PayBean payBean;
  late VipBean vipBean;
  late int payKeyType;
  late int goodsId;
  late int isWx;
  late int isZfb;
  late RxInt statePay;
  VipState() {
    payBean = PayBean();
    vipBean = VipBean();
    isCheck=false.obs;
    itemIndex=0;
    payKeyType=0;
    goodsId=0;
    isWx=0;
    isZfb=0;
    type=0;
    statePay=0.obs;

  }
}
