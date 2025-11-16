// ignore_for_file: constant_identifier_names

/// API 配置类
class ApiConfig {
  // 私有构造函数，防止实例化
  ApiConfig._();

  // ========== 环境配置 ==========
  /// 开发环境
  static const String debugBaseUrl = "http://photo.jlhkj168.cn";

  /// 正式环境
  static const String releaseBaseUrl = "http://photo.jlhkj168.cn";

  // ========== 配置项 ==========
  /// 连接超时时间（秒）
  static const int connectTimeout = 10;

  /// 接收超时时间（秒）
  static const int receiveTimeout = 15;

  /// 发送超时时间（秒）
  static const int sendTimeout = 15;

  // ========== API 路径 ==========

  /// 更新
  static const String getForcePackage = "/packge/getForcePackage";

  /// 获取用户信息
  static const String sso_getUserInfo = "/getUserInfo";

  /// 账号密码登录
  static const String accountLogin = "/accountLogin";

  /// 注销
  static const String deleteUser = "/deleteUser";

  /// 查询历史记录
  static const String photoRecord = "/photoRecord/pageRecord";

  /// 签约接口
  static const String payOrder_addUserAgreementOrder = "/center/addUserAgreementOrder";

  /// 下单接口
  static const String payOrder_addOrder = "/center/createOrder";

  /// 获取vip页面数据
  static const String vip_getVipHome = "/center/getVipShowMsg";

  static const String getFuncDetail = "/photoFunc/getFuncDetail";

  static const String delete = "/photoRecord/delete";

  /// 订单列表
  static const String payOrder_listOrder = "/payOrder/listOrder";

  /// 渠道更新
  static const String appPackage_latestPackage = "/center/latestPackage";

  /// 协议
  static const String center_getProtocolConfig = "/center/getProtocolConfig";

  /// 获取挽留vip数据
  static const String vip_getVipPageDisposable = "/vip/getVipPageDisposable";

  /// 绑定手机号
  static const String sso_bindUserPhone = "/sso/bindUserPhone";

  /// 新增血糖
  static const String bloodRecord_addBloodRecord = "/bloodRecord/addBloodRecord";

  /// 血糖记录
  static const String bloodRecord_pageList = "/bloodRecord/pageList";

  /// 上传文件
  static const String uploadFile = "/upload/uploadFile";

  /// 设置默认头像
  static const String bindDefaultImg = "/bindDefaultImg";

  /// Get查询分类-合集-玩法 groupType:分类类型(GroupType 0:分类 1:合集 2:玩法)
  /// tabType 展示tab位置(TabType 0:视频 1:图片 2:特效)
  static const String listPhotoGroup = "/photoGroup/listPhotoGroup";

  /// Get 查询玩法下分类 id
  static const String effectGroupList = "/photoGroup/effectGroupList";

  /// Get 查询分类下(模板合集)或合集下模板 id 分类或合集id
  static const String pagePhotoGroupBind = "/photoGroup/pagePhotoGroupBind";

  /// 智能扩图
  static const String outPaint = "/photoRecord/outPaint";

  /// 智能消除
  static const String smartRemove = "/photoRecord/smartRemove";

  /// 风格
  static const String defTimbreVO = "/photoRecord/defTimbreVO";

  /// 添加处理图片
  static const String addPhotoRecord = "/photoRecord/addPhotoRecord";

  /// 重新制作
  static const String remakePhotoRecord = "/photoRecord/remakePhotoRecord";

  /// 生成艺术字
  static const String addTask = "/wordDart/addTask";

  /// 艺术字-生肖03
  static const String animalsEnum = "/enum/animalsEnum";

  /// 艺术字-奶茶头像06
  static const String milkTeaEnum = "/enum/milkTeaEnum";

  /// 艺术字-卡通情侣09
  static const String cartoonEnum = "/enum/cartoonEnum";

  /// 艺术字-卡通头像女孩10
  static const String cartoonGirlEnum = "/enum/cartoonGirlEnum";

  /// 艺术字-卡通头像男孩11
  static const String cartoonBoyEnum = "/enum/cartoonBoyEnum";

  /// 获取api类型
  static const String apiTypeList = "/enum/apiTypeList";

  /// ios恢复订单
  static const String payOrder_restoreIosPay = "/center/handleIosOrder";

  /// ios内购回调
  static const String payOrder_iosPay = "/center/handleIosOrder";

  /// Get检查图片是否包含人脸
  static const String imgHaveFace = "/imgHaveFace";

  /// Get查询模板所有分类或合集其他的模板
  static const String getGroupOtherFuncList = "/photoFunc/getGroupOtherFuncList";

  /// 登录
  static const String sso_login = "/authenticate";

  /// 退出登录
  static const String logout = "/logout";

  /// 微信登录
  static const String authorizeByWx = "/authorizeByWx";

  /// token登录
  static const String authByToken = "/authByToken";

  /// 获取智能体
  static const String getSmartModel = "/configSmartModel/listAll";

  /// iOS登录
  static const String authorizeByIos = '/authorizeByIos';

  /// 获取配置
  static const String getConfigByKey = '/sysConfig/getConfigByKey?key=IOS_OPEN_FLAG';
}
