import 'package:zpw/common/zpw_constant.dart';

///数据解析的基础类
class ZpwBaseResponse<T> {
  int? zpwCode;
  String? zpwMessage;
  List<T> zpwListData = [];

  ZpwBaseResponse(this.zpwCode, this.zpwMessage, this.zpwListData);

  ZpwBaseResponse.fromJson(Map<String, dynamic> json) {
    zpwCode = json[ZpwConstant.zpwCode] ?? 0;
    zpwMessage = json[ZpwConstant.zpwMessage] ?? "error";
    if (json["listData"] != null) {
      zpwListData = json["listData"];
    } else {
      zpwListData = [];
    }
  }
}