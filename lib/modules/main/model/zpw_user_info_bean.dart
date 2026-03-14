import 'dart:convert';

class ZpwUserInfoBean {
  num? age;
  String? authToken;
  num? bmi;
  num? createNum;
  String? gender;
  String? headImg;
  num? height;
  num? id;
  bool? isSignTask;
  String? invatecode;
  bool? isMember;
  bool? isNewUser;
  bool? isWxOauth;
  dynamic vipExpireTime;
  String? motion;
  String? nickName;
  num? targetWeight;
  num? initWeight;
  num? vipFlag;
  num? permanentFlag;
  String? userPhone;
  num? weight;
  String? wxNickName;

  ZpwUserInfoBean({
    this.age,
    this.authToken,
    this.bmi,
    this.createNum,
    this.gender,
    this.headImg,
    this.height,
    this.id,
    this.isSignTask,
    this.invatecode,
    this.isMember,
    this.isNewUser,
    this.isWxOauth,
    this.vipExpireTime,
    this.motion,
    this.vipFlag,
    this.permanentFlag,
    this.nickName,
    this.targetWeight,
    this.initWeight,
    this.userPhone,
    this.weight,
    this.wxNickName,
  });

  factory ZpwUserInfoBean.fromRawJson(String str) => ZpwUserInfoBean.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ZpwUserInfoBean.fromJson(Map<String, dynamic> json) => ZpwUserInfoBean(
        age: json["age"],
        createNum: json["createNum"],
        authToken: json["authToken"],
        bmi: json["bmi"]?.toDouble(),
        gender: json["gender"],
        headImg: json["headImg"],
        height: json["height"],
        id: json["id"],
        isSignTask: json["isSignTask"],
        invatecode: json["invatecode"],
        isMember: json["isMember"],
        isNewUser: json["isNewUser"],
        isWxOauth: json["isWxOauth"],
        vipExpireTime: json["vipExpireTime"],
        vipFlag: json["vipFlag"],
        permanentFlag: json["permanentFlag"],
        motion: json["motion"],
        nickName: json["nickName"],
        targetWeight: json["targetWeight"]?.toDouble(),
        userPhone: json["userPhone"],
        weight: json["weight"]?.toDouble(),
        initWeight: json["initWeight"]?.toDouble(),
        wxNickName: json["wxNickName"],
      );

  Map<String, dynamic> toJson() => {
        "age": age,
        "createNum": createNum,
        "authToken": authToken,
        "bmi": bmi,
        "vipFlag": vipFlag,
        "permanentFlag": permanentFlag,
        "gender": gender,
        "headImg": headImg,
        "height": height,
        "id": id,
        "isSignTask": isSignTask,
        "invatecode": invatecode,
        "isMember": isMember,
        "isNewUser": isNewUser,
        "isWxOauth": isWxOauth,
        "vipExpireTime": vipExpireTime,
        "motion": motion,
        "nickName": nickName,
        "targetWeight": targetWeight,
        "userPhone": userPhone,
        "weight": weight,
        "initWeight": initWeight,
        "wxNickName": wxNickName,
      };
}
