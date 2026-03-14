// ignore_for_file: constant_identifier_names

///管理错误码的状态
class ZpwErrorStatus {
  //数据成功的Code
  static const int zpwRequestDataOk = 0;

  //请求成功
  static const int zpwSuccess = 200;

  //服务器拒绝访问
  static const int zpwForbidden = 403;

  static const int zpwNotFound = 404;

  //其他错误
  static const int zpwUnknownError = 1000;

  //网络异常
  static const int zpwNetworkError = 1001;

  //服务器连接错误
  static const int zpwSocketError = 1002;

  //服务器内部错误
  static const int zpwServerError = 1003;

  //连接超时
  static const int zpwTimeoutError = 1004;

  //网络请求取消
  static const int zpwCancelError = 1005;

  //数据转对象错误
  static const int zpwParseError = 1006;
}