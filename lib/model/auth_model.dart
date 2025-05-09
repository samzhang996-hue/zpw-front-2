class AuthModel {
  String? token;
  num? userId;

  int? registerFlag;

  bool get isRegister => registerFlag == 1;

  AuthModel({
    this.token,
    this.userId,
    this.registerFlag,
  });

  AuthModel.fromJson(dynamic json) {
    token = json['token'];
    userId = json['userId'] as num?;
    registerFlag = json['registerFlag'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = token;
    data['userId'] = userId;
    data['registerFlag'] = registerFlag;
    return data;
  }
}
