// ignore_for_file: constant_identifier_names

class Api {
  //本地
  static const String API_BASE_URL_DEBUG = "http://zpwservice.qwstkj.com";


  ///正式
  static const String API_BASE_URL_RELEASE = "http://zpwservice.qwstkj.com";

  /// 获取协议集合
  static const String config_getConFigByTypeList =
      "/config/getConFigByTypeList";

  /// 更新
  static const String getForcePackage = "/packge/getForcePackage";

  ///登录
  static const String sso_login = "/sso/login";

  /// 获取用户信息
  static const String sso_getUserInfo = "/sso/getUserInfo";

  ///签约接口
  static const String payOrder_addUserAgreementOrder =
      "/center/addUserAgreementOrder";

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
  static const String bloodRecord_addBloodRecord =
      "/bloodRecord/addBloodRecord";

  ///血糖记录
  static const String bloodRecord_pageList = "/bloodRecord/pageList";
}
