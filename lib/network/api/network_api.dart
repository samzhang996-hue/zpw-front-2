// ignore_for_file: constant_identifier_names

class Api {
  //本地
  // static const String API_BASE_URL_DEBUG = "http://8.130.84.131:4001";
  static const String API_BASE_URL_DEBUG = "http://photo.jlhkj168.cn";

  ///正式
  static const String API_BASE_URL_RELEASE = "http://photo.jlhkj168.cn";

  /// 更新
  static const String getForcePackage = "/packge/getForcePackage";

  ///登录
  static const String sso_login = "/authenticate";

  /// 获取用户信息
  static const String sso_getUserInfo = "/getUserInfo";

  /// 注销
  static const String deleteUser = "/deleteUser";

  /// 查询历史记录
  static const String photoRecord = "/photoRecord/pageRecord";












  ///签约接口
  static const String payOrder_addUserAgreementOrder = "/center/addUserAgreementOrder";

  /// 下单接口
  static const String payOrder_addOrder = "/center/createOrder";

  /// 获取vip页面数据
  static const String vip_getVipHome = "/center/getVipShowMsg";

  /// 订单列表
  static const String payOrder_listOrder = "/payOrder/listOrder";

  /// 渠道更新
  static const String appPackage_latestPackage = "/center/latestPackage";

  ///协议
  static const String center_getProtocolConfig = "/center/getProtocolConfig";

  ///获取挽留vip数据
  static const String vip_getVipPageDisposable = "/vip/getVipPageDisposable";

  ///绑定手机号
  static const String sso_bindUserPhone = "/sso/bindUserPhone";

  ///新增血糖
  static const String bloodRecord_addBloodRecord = "/bloodRecord/addBloodRecord";

  ///血糖记录
  static const String bloodRecord_pageList = "/bloodRecord/pageList";
}
