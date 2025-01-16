import 'dart:convert';

class PayBean {
  GenerateSignVo? generateSignVo;
  String? orderId;
  num? orderStatus;
  num? payId;
  num? payTerrace;
  num? payKeyType;
  ZfbPayOrderVo? zfbPayOrderVo;
  ZfbServerPayOrderVo? zfbServerPayOrderVo;

  PayBean({
    this.generateSignVo,
    this.orderId,
    this.orderStatus,
    this.payId,
    this.payTerrace,
    this.payKeyType,
    this.zfbPayOrderVo,
    this.zfbServerPayOrderVo,
  });

  factory PayBean.fromRawJson(String str) => PayBean.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PayBean.fromJson(Map<String, dynamic> json) => PayBean(
        generateSignVo: json["generateSignVo"] == null
            ? null
            : GenerateSignVo.fromJson(json["generateSignVo"]),
        orderId: json["orderId"],
        orderStatus: json["orderStatus"],
        payId: json["payId"],
        payTerrace: json["payTerrace"],
        payKeyType: json["payKeyType"],
        zfbPayOrderVo: json["zfbPayOrderVo"] == null
            ? null
            : ZfbPayOrderVo.fromJson(json["zfbPayOrderVo"]),
        zfbServerPayOrderVo: json["zfbServerPayOrderVo"] == null
            ? null
            : ZfbServerPayOrderVo.fromJson(json["zfbServerPayOrderVo"]),
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

class ZfbPayOrderVo {
  String? appId;
  String? trademsg;

  ZfbPayOrderVo({
    this.appId,
    this.trademsg,
  });

  factory ZfbPayOrderVo.fromRawJson(String str) =>
      ZfbPayOrderVo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ZfbPayOrderVo.fromJson(Map<String, dynamic> json) => ZfbPayOrderVo(
        appId: json["appId"],
        trademsg: json["trademsg"],
      );

  Map<String, dynamic> toJson() => {
        "appId": appId,
        "trademsg": trademsg,
      };
}

class ZfbServerPayOrderVo {
  String? appId;
  String? jumpUrl;
  String? outTradeNo;

  ZfbServerPayOrderVo({
    this.appId,
    this.jumpUrl,
    this.outTradeNo,
  });

  factory ZfbServerPayOrderVo.fromRawJson(String str) =>
      ZfbServerPayOrderVo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ZfbServerPayOrderVo.fromJson(Map<String, dynamic> json) =>
      ZfbServerPayOrderVo(
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

class GenerateSignVo {
  String? appId;
  String? nonceStr;
  String? packageValue;
  String? partnerId;
  String? prepayId;
  String? sing;
  String? timeStamp;

  GenerateSignVo({
    this.appId,
    this.nonceStr,
    this.packageValue,
    this.partnerId,
    this.prepayId,
    this.sing,
    this.timeStamp,
  });

  factory GenerateSignVo.fromRawJson(String str) =>
      GenerateSignVo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenerateSignVo.fromJson(Map<String, dynamic> json) => GenerateSignVo(
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
