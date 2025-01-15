
import 'package:zpw/common/constant.dart';

///数据解析的基础类
class BaseResponse<T> {
  int? code;
  String? message;
  List<T> listData = [];

  BaseResponse(this.code, this.message, this.listData);

  BaseResponse.fromJson(Map<String, dynamic> json) {
    code = json[Constant.code] ?? 0;
    message = json[Constant.message] ?? "error";
    if (json["listData"] != null) {
      listData = json["listData"];
    } else {
      listData = [];
    }
  }
}
