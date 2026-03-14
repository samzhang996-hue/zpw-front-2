// ignore_for_file: constant_identifier_names

class ZpwApi {
  //本地
  // static const String zpwApiBaseUrlDebug = "http://8.130.84.131:4001";
  static const String zpwApiBaseUrlDebug = "http://photo.jlhkj168.cn";

  // static const String zpwApiBaseUrlDebug = "http://192.168.1.231:4001";
  // static const String zpwApiBaseUrlDebug = "http://192.168.1.231:4001/";

  ///正式
  static const String zpwApiBaseUrlRelease = "http://photo.jlhkj168.cn";

  // static const String zpwApiBaseUrlRelease = "http://192.168.1.231:5000";

  /// 更新
  static const String zpwGetForcePackage = "/packge/getForcePackage";

  /// 获取用户信息
  static const String zpwSsoGetUserInfo = "/getUserInfo";

  ///账号密码登录
  static const String zpwAccountLogin = "/accountLogin";

  /// 注销
  static const String zpwDeleteUser = "/deleteUser";

  /// 查询历史记录
  static const String zpwPhotoRecord = "/photoRecord/pageRecord";

  ///签约接口
  static const String zpwPayOrderAddUserAgreementOrder = "/center/addUserAgreementOrder";

  /// 下单接口
  static const String zpwPayOrderAddOrder = "/center/createOrder";

  /// 获取vip页面数据
  static const String zpwVipGetVipHome = "/center/getVipShowMsg";

  static const String zpwGetFuncDetail = "/photoFunc/getFuncDetail";

  static const String zpwDelete = "/photoRecord/delete";

  /// 订单列表
  static const String zpwPayOrderListOrder = "/payOrder/listOrder";

  /// 渠道更新
  static const String zpwAppPackageLatestPackage = "/center/latestPackage";

  ///协议
  static const String zpwCenterGetProtocolConfig = "/center/getProtocolConfig";

  ///获取挽留vip数据
  static const String zpwVipGetVipPageDisposable = "/vip/getVipPageDisposable";

  ///绑定手机号
  static const String zpwSsoBindUserPhone = "/sso/bindUserPhone";

  ///新增血糖
  static const String zpwBloodRecordAddBloodRecord = "/bloodRecord/addBloodRecord";

  ///血糖记录
  static const String zpwBloodRecordPageList = "/bloodRecord/pageList";

  ///上传文件
  // static const String zpwLocalUploadFile = "/upload/localUploadFile";

  ///上传文件
  static const String zpwUploadFile = "/upload/uploadFile";

  ///设置默认头像
  static const String zpwBindDefaultImg = "/bindDefaultImg";

  ///Get查询分类-合集-玩法 groupType:分类类型(GroupType 0:分类 1:合集 2:玩法)
  ///tabType	展示tab位置(TabType 0:视频 1:图片 2:特效)
  ///http://photo.jlhkj168.cn/doc.html#/App%20Knife4j%20doc/%E7%85%A7%E7%89%87%E7%BB%84%E5%90%88%E8%A1%A8/listPhotoGroupUsingGET
  static const String zpwListPhotoGroup = "/photoGroup/listPhotoGroup";

  ///Get 查询玩法下分类 id
  ///http://photo.jlhkj168.cn/doc.html#/App%20Knife4j%20doc/%E7%85%A7%E7%89%87%E7%BB%84%E5%90%88%E8%A1%A8/effectGroupListUsingGET
  static const String zpwEffectGroupList = "/photoGroup/effectGroupList";

  ///Get 查询分类下(模板合集)或合集下模板 id 分类或合集id
  ///http://photo.jlhkj168.cn/doc.html#/App%20Knife4j%20doc/%E7%85%A7%E7%89%87%E7%BB%84%E5%90%88%E8%A1%A8/pagePhotoGroupBindUsingGET
  static const String zpwPagePhotoGroupBind = "/photoGroup/pagePhotoGroupBind";

  ///智能扩图
  static const String zpwOutPaint = "/photoRecord/outPaint";

  ///智能消除
  static const String zpwSmartRemove = "/photoRecord/smartRemove";

  ///风格
  static const String zpwDefTimbreVO = "/photoRecord/defTimbreVO";

  ///添加处理图片
  static const String zpwAddPhotoRecord = "/photoRecord/addPhotoRecord";

  ///重新制作
  static const String zpwRemakePhotoRecord = "/photoRecord/remakePhotoRecord";

  ///生成艺术字
  static const String zpwAddTask = "/wordDart/addTask";

  ///艺术字-生肖03
  static const String zpwAnimalsEnum = "/enum/animalsEnum";

  ///艺术字-奶茶头像06
  static const String zpwMilkTeaEnum = "/enum/milkTeaEnum";

  ///艺术字-卡通情侣09
  static const String zpwCartoonEnum = "/enum/cartoonEnum";

  ///艺术字-卡通头像女孩10
  static const String zpwCartoonGirlEnum = "/enum/cartoonGirlEnum";

  ///艺术字-卡通头像男孩11
  static const String zpwCartoonBoyEnum = "/enum/cartoonBoyEnum";

  ///获取api类型
  static const String zpwApiTypeList = "/enum/apiTypeList";

  ///ios恢复订单
  static const String zpwPayOrderRestoreIosPay = "/center/handleIosOrder";

  ///ios内购回调
  static const String zpwPayOrderIosPay = "/center/handleIosOrder";

  ///Get检查图片是否包含人脸
  static const String zpwImgHaveFace = "/imgHaveFace";

  ///Get查询模板所有分类或合集其他的模板
  static const String zpwGetGroupOtherFuncList = "/photoFunc/getGroupOtherFuncList";

  ///登录
  static const String zpwSsoLogin = "/authenticate";

  ///退出登录
  static const String zpwLogout = "/logout";

  ///微信登陆
  static const String zpwAuthorizeByWx = "/authorizeByWx";

  ///token登陆
  static const String zpwAuthByToken = "/authByToken";
}