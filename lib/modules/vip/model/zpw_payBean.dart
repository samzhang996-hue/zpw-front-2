import 'dart:convert';

class ZpwPayBean {
  ZpwGenerateSignVo? generateSignVo;
  String? orderId;
  num? orderStatus;
  num? payId;
  num? payTerrace;
  num? payKeyType;
  ZpwZfbPayOrderVo? zfbPayOrderVo;
  ZpwZfbServerPayOrderVo? zfbServerPayOrderVo;

  ZpwPayBean({
    this.generateSignVo,
    this.orderId,
    this.orderStatus,
    this.payId,
    this.payTerrace,
    this.payKeyType,
    this.zfbPayOrderVo,
    this.zfbServerPayOrderVo,
  });

  factory ZpwPayBean.fromRawJson(String str) => ZpwPayBean.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ZpwPayBean.fromJson(Map<String, dynamic> json) => ZpwPayBean(
        generateSignVo: json["generateSignVo"] == null
            ? null
            : ZpwGenerateSignVo.fromJson(json["generateSignVo"]),
        orderId: json["orderId"],
        orderStatus: json["orderStatus"],
        payId: json["payId"],
        payTerrace: json["payTerrace"],
        payKeyType: json["payKeyType"],
        zfbPayOrderVo: json["zfbPayOrderVo"] == null
            ? null
            : ZpwZfbPayOrderVo.fromJson(json["zfbPayOrderVo"]),
        zfbServerPayOrderVo: json["zfbServerPayOrderVo"] == null
            ? null
            : ZpwZfbServerPayOrderVo.fromJson(json["zfbServerPayOrderVo"]),
      );

  Map<String, dynamic> toJson() => {
        "generateSignVo": generateSignVo?.toJson(),
        "orderId": orderId,
        "orderStatus": orderStatus,
        "payId": payId,
        "payTerrace": payTerrace,
        "payKeyType": payKeyType,
        "zfbPayOrderVo": zfbPayOrderVo?.toJson(),
        "zfbServerPayOrderVo": zfbServerPayOrderVo?.toJson(),
      };
}

class ZpwZfbPayOrderVo {
  String? appId;
  String? trademsg;

  ZpwZfbPayOrderVo({
    this.appId,
    this.trademsg,
  });

  factory ZpwZfbPayOrderVo.fromRawJson(String str) =>
      ZpwZfbPayOrderVo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ZpwZfbPayOrderVo.fromJson(Map<String, dynamic> json) => ZpwZfbPayOrderVo(
        appId: json["appId"],
        trademsg: json["trademsg"],
      );

  Map<String, dynamic> toJson() => {
        "appId": appId,
        "trademsg": trademsg,
      };
}

class ZpwZfbServerPayOrderVo {
  String? appId;
  String? jumpUrl;
  String? outTradeNo;

  ZpwZfbServerPayOrderVo({
    this.appId,
    this.jumpUrl,
    this.outTradeNo,
  });

  factory ZpwZfbServerPayOrderVo.fromRawJson(String str) =>
      ZpwZfbServerPayOrderVo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ZpwZfbServerPayOrderVo.fromJson(Map<String, dynamic> json) =>
      ZpwZfbServerPayOrderVo(
        appId: json["appId"],
        jumpUrl: json["jumpUrl"],
        outTradeNo: json["outTradeNo"],
      );

  Map<String, dynamic> toJson() => {
        "appId": appId,
        "jumpUrl": jumpUrl,
        "outTradeNo": outTradeNo,
      };
}

class ZpwGenerateSignVo {
  String? appId;
  String? nonceStr;
  String? packageValue;
  String? partnerId;
  String? prepayId;
  String? sing;
  String? timeStamp;

  ZpwGenerateSignVo({
    this.appId,
    this.nonceStr,
    this.packageValue,
    this.partnerId,
    this.prepayId,
    this.sing,
    this.timeStamp,
  });

  factory ZpwGenerateSignVo.fromRawJson(String str) =>
      ZpwGenerateSignVo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ZpwGenerateSignVo.fromJson(Map<String, dynamic> json) => ZpwGenerateSignVo(
        appId: json["appId"],
        nonceStr: json["nonceStr"],
        packageValue: json["packageValue"],
        partnerId: json["partnerId"],
        prepayId: json["prepayId"],
        sing: json["sing"],
        timeStamp: json["timeStamp"],
      );

  Map<String, dynamic> toJson() => {
        "appId": appId,
        "nonceStr": nonceStr,
        "packageValue": packageValue,
        "partnerId": partnerId,
        "prepayId": prepayId,
        "sing": sing,
        "timeStamp": timeStamp,
      };
}