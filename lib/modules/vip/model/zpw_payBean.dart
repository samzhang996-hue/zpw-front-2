import 'dart:convert';

class ZpwPayBean {
  ZpwGenerateSignVo? zpwGenerateSignVo;
  String? zpwOrderId;
  num? zpwOrderStatus;
  num? zpwPayId;
  num? zpwPayTerrace;
  num? zpwPayKeyType;
  ZpwZfbPayOrderVo? zpwZfbPayOrderVo;
  ZpwZfbServerPayOrderVo? zpwZfbServerPayOrderVo;

  ZpwPayBean({
    this.zpwGenerateSignVo,
    this.zpwOrderId,
    this.zpwOrderStatus,
    this.zpwPayId,
    this.zpwPayTerrace,
    this.zpwPayKeyType,
    this.zpwZfbPayOrderVo,
    this.zpwZfbServerPayOrderVo,
  });

  factory ZpwPayBean.fromRawJson(String str) => ZpwPayBean.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ZpwPayBean.fromJson(Map<String, dynamic> json) => ZpwPayBean(
        zpwGenerateSignVo: json["generateSignVo"] == null
            ? null
            : ZpwGenerateSignVo.fromJson(json["generateSignVo"]),
        zpwOrderId: json["orderId"],
        zpwOrderStatus: json["orderStatus"],
        zpwPayId: json["payId"],
        zpwPayTerrace: json["payTerrace"],
        zpwPayKeyType: json["payKeyType"],
        zpwZfbPayOrderVo: json["zfbPayOrderVo"] == null
            ? null
            : ZpwZfbPayOrderVo.fromJson(json["zfbPayOrderVo"]),
        zpwZfbServerPayOrderVo: json["zfbServerPayOrderVo"] == null
            ? null
            : ZpwZfbServerPayOrderVo.fromJson(json["zfbServerPayOrderVo"]),
      );

  Map<String, dynamic> toJson() => {
        "generateSignVo": zpwGenerateSignVo?.toJson(),
        "orderId": zpwOrderId,
        "orderStatus": zpwOrderStatus,
        "payId": zpwPayId,
        "payTerrace": zpwPayTerrace,
        "payKeyType": zpwPayKeyType,
        "zfbPayOrderVo": zpwZfbPayOrderVo?.toJson(),
        "zfbServerPayOrderVo": zpwZfbServerPayOrderVo?.toJson(),
      };
}

class ZpwZfbPayOrderVo {
  String? zpwAppId;
  String? zpwTrademsg;

  ZpwZfbPayOrderVo({
    this.zpwAppId,
    this.zpwTrademsg,
  });

  factory ZpwZfbPayOrderVo.fromRawJson(String str) =>
      ZpwZfbPayOrderVo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ZpwZfbPayOrderVo.fromJson(Map<String, dynamic> json) => ZpwZfbPayOrderVo(
        zpwAppId: json["appId"],
        zpwTrademsg: json["trademsg"],
      );

  Map<String, dynamic> toJson() => {
        "appId": zpwAppId,
        "trademsg": zpwTrademsg,
      };
}

class ZpwZfbServerPayOrderVo {
  String? zpwAppId;
  String? zpwJumpUrl;
  String? zpwOutTradeNo;

  ZpwZfbServerPayOrderVo({
    this.zpwAppId,
    this.zpwJumpUrl,
    this.zpwOutTradeNo,
  });

  factory ZpwZfbServerPayOrderVo.fromRawJson(String str) =>
      ZpwZfbServerPayOrderVo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ZpwZfbServerPayOrderVo.fromJson(Map<String, dynamic> json) =>
      ZpwZfbServerPayOrderVo(
        zpwAppId: json["appId"],
        zpwJumpUrl: json["jumpUrl"],
        zpwOutTradeNo: json["outTradeNo"],
      );

  Map<String, dynamic> toJson() => {
        "appId": zpwAppId,
        "jumpUrl": zpwJumpUrl,
        "outTradeNo": zpwOutTradeNo,
      };
}

class ZpwGenerateSignVo {
  String? zpwAppId;
  String? zpwNonceStr;
  String? zpwPackageValue;
  String? zpwPartnerId;
  String? zpwPrepayId;
  String? zpwSing;
  String? zpwTimeStamp;

  ZpwGenerateSignVo({
    this.zpwAppId,
    this.zpwNonceStr,
    this.zpwPackageValue,
    this.zpwPartnerId,
    this.zpwPrepayId,
    this.zpwSing,
    this.zpwTimeStamp,
  });

  factory ZpwGenerateSignVo.fromRawJson(String str) =>
      ZpwGenerateSignVo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ZpwGenerateSignVo.fromJson(Map<String, dynamic> json) => ZpwGenerateSignVo(
        zpwAppId: json["appId"],
        zpwNonceStr: json["nonceStr"],
        zpwPackageValue: json["packageValue"],
        zpwPartnerId: json["partnerId"],
        zpwPrepayId: json["prepayId"],
        zpwSing: json["sing"],
        zpwTimeStamp: json["timeStamp"],
      );

  Map<String, dynamic> toJson() => {
        "appId": zpwAppId,
        "nonceStr": zpwNonceStr,
        "packageValue": zpwPackageValue,
        "partnerId": zpwPartnerId,
        "prepayId": zpwPrepayId,
        "sing": zpwSing,
        "timeStamp": zpwTimeStamp,
      };
}