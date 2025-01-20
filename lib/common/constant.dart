class Constant {
  ///debug的开关，由于控制上限的需要关闭的业务
  ///App运行Release时候,inProduction为true; 为Debug的时候为false
  static const bool inProduction = bool.fromEnvironment("dart.vm.product");
  static const String data = "data";
  static const String message = "message";
  static const String code = "code";
}

// 扩展 String 类型
extension ImageLoad on String {
  /// 获取图片全路径
  String get tabbar => 'images/tabbar/$this';
  String get home => 'images/home/$this';
  String get img => 'images/tabbar/$this';
  String get mine => 'images/mine/$this';
  String get comm => 'images/comm/$this';
  String get vip => 'images/vip/$this';
  String get make => 'images/make/$this';
  String get face => 'images/face/$this';
}
