/// 统一的网络响应数据模型
class BaseResponse<T> {
  /// 状态码
  final int code;

  /// 提示信息
  final String message;

  /// 响应数据
  final T? data;

  BaseResponse({
    required this.code,
    required this.message,
    this.data,
  });

  /// 从 JSON 创建对象
  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return BaseResponse<T>(
      code: json['code'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data,
    };
  }

  /// 判断请求是否成功 (code == 100 表示成功)
  bool get isSuccess => code == 100;

  @override
  String toString() {
    return 'BaseResponse{code: $code, message: $message, data: $data}';
  }
}
