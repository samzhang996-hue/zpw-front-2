/// 网络请求响应结果封装
class ZpwNetResult<T> {
  final bool isSuccess;
  final int code;
  final String message;
  final List<T> data;

  ZpwNetResult({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.data,
  });

  /// 获取第一个数据，如果为空返回 null
  T? get first => data.isNotEmpty ? data.first : null;

  /// 是否有数据
  bool get hasData => data.isNotEmpty;

  /// 请求是否成功 (code == 100)
  bool get isOk => code == 100;
}