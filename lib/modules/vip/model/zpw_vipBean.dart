import 'dart:convert';

class ZpwVipBean {
  String? zpwChannel;
  List<ZpwPList>? zpwContentPopList;
  String? zpwCreateTime;
  List<ZpwPList>? zpwHomePopList;
  int? zpwId;
  List<ZpwPList>? zpwOtherPopList;
  int? zpwProjectId;
  List<ZpwPList>? zpwVipList;
  List<ZpwPList>? zpwVipPopList;

  ZpwVipBean({
    this.zpwChannel,
    this.zpwContentPopList,
    this.zpwCreateTime,
    this.zpwHomePopList,
    this.zpwId,
    this.zpwOtherPopList,
    this.zpwProjectId,
    this.zpwVipList,
    this.zpwVipPopList,
  });

  factory ZpwVipBean.fromRawJson(String str) => ZpwVipBean.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ZpwVipBean.fromJson(Map<String, dynamic> json) => ZpwVipBean(
    zpwChannel: json["channel"],
    zpwContentPopList: json["contentPopList"] == null ? [] : List<ZpwPList>.from(json["contentPopList"]!.map((x) => ZpwPList.fromJson(x))),
    zpwCreateTime: json["createTime"] ,
    zpwHomePopList: json["homePopList"] == null ? [] : List<ZpwPList>.from(json["homePopList"]!.map((x) =>  ZpwPList.fromJson(x))),
    zpwId: json["id"],
    zpwOtherPopList: json["otherPopList"] == null ? [] : List<ZpwPList>.from(json["otherPopList"]!.map((x) => ZpwPList.fromJson(x))),
    zpwProjectId: json["projectId"],
    zpwVipList: json["vipList"] == null ? [] : List<ZpwPList>.from(json["vipList"]!.map((x) => ZpwPList.fromJson(x))),
    zpwVipPopList: json["vipPopList"] == null ? [] : List<ZpwPList>.from(json["vipPopList"]!.map((x) =>  ZpwPList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "channel": zpwChannel,
    "contentPopList": zpwContentPopList == null ? [] : List<dynamic>.from(zpwContentPopList!.map((x) => x.toJson())),
    "createTime": zpwCreateTime,
    "homePopList": zpwHomePopList == null ? [] : List<dynamic>.from(zpwHomePopList!.map((x) => x.toJson())),
    "id": zpwId,
    "otherPopList": zpwOtherPopList == null ? [] : List<dynamic>.from(zpwOtherPopList!.map((x) => x.toJson())),
    "projectId": zpwProjectId,
    "vipList": zpwVipList == null ? [] : List<dynamic>.from(zpwVipList!.map((x) => x.toJson())),
    "vipPopList": zpwVipPopList == null ? [] : List<dynamic>.from(zpwVipPopList!.map((x) => x.toJson())),
  };
}

class ZpwPList {
  dynamic zpwIsPayOne;
  String? zpwRemark1;
  String? zpwRemark10;
  String? zpwRemark2;
  String? zpwRemark3;
  String? zpwRemark4;
  String? zpwRemark5;
  String? zpwRemark6;
  String? zpwRemark7;
  String? zpwRemark8;
  String? zpwRemark9;
  String? zpwShowRemark;
  int? zpwSortId;
  int? zpwVipPriceId;
  ZpwVipPriceOutput? zpwVipPriceOutput;

  ZpwPList({
    this.zpwIsPayOne,
    this.zpwRemark1,
    this.zpwRemark10,
    this.zpwRemark2,
    this.zpwRemark3,
    this.zpwRemark4,
    this.zpwRemark5,
    this.zpwRemark6,
    this.zpwRemark7,
    this.zpwRemark8,
    this.zpwRemark9,
    this.zpwShowRemark,
    this.zpwSortId,
    this.zpwVipPriceId,
    this.zpwVipPriceOutput,
  });

  factory ZpwPList.fromRawJson(String str) => ZpwPList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ZpwPList.fromJson(Map<String, dynamic> json) => ZpwPList(
    zpwIsPayOne: json["isPayOne"],
    zpwRemark1: json["remark1"],
    zpwRemark10: json["remark10"],
    zpwRemark2: json["remark2"],
    zpwRemark3: json["remark3"],
    zpwRemark4: json["remark4"],
    zpwRemark5: json["remark5"],
    zpwRemark6: json["remark6"],
    zpwRemark7: json["remark7"],
    zpwRemark8: json["remark8"],
    zpwRemark9: json["remark9"],
    zpwShowRemark: json["showRemark"],
    zpwSortId: json["sortId"],
    zpwVipPriceId: json["vipPriceId"],
    zpwVipPriceOutput: json["vipPriceOutput"] == null ? null : ZpwVipPriceOutput.fromJson(json["vipPriceOutput"]),
  );

  Map<String, dynamic> toJson() => {
    "isPayOne": zpwIsPayOne,
    "remark1": zpwRemark1,
    "remark10": zpwRemark10,
    "remark2": zpwRemark2,
    "remark3": zpwRemark3,
    "remark4": zpwRemark4,
    "remark5": zpwRemark5,
    "remark6": zpwRemark6,
    "remark7": zpwRemark7,
    "remark8": zpwRemark8,
    "remark9": zpwRemark9,
    "showRemark": zpwShowRemark,
    "sortId": zpwSortId,
    "vipPriceId": zpwVipPriceId,
    "vipPriceOutput": zpwVipPriceOutput?.toJson(),
  };
}

class ZpwVipPriceOutput {
  int? zpwAgreemenPayNum;
  int? zpwAgreemenPayments;
  int? zpwAgreemenPrice;
  int? zpwAgreemenTime;
  String? zpwAgreemenTimeType;
  int? zpwAgreemenType;
  int? zpwCollTime;
  String? zpwCollTimeType;
  int? zpwDecreaseMoney;
  int? zpwId;
  dynamic zpwIosProductId;
  int? zpwIsDisposable;
  int? zpwIsIosPay;
  int? zpwIsWithdrawal;
  int? zpwIsWxPay;
  int? zpwIsZfbPay;
  int? zpwOriginalPrice;
  String? zpwPayName;
  int? zpwPrice;
  int? zpwDefaultPayKeyType;
  int? zpwDefaultZfbPayKeyType;
  String? zpwShowName;
  String? zpwVipName;
  int? zpwVipTime;
  String? zpwVipTimeType;

  ZpwVipPriceOutput({
    this.zpwAgreemenPayNum,
    this.zpwAgreemenPayments,
    this.zpwAgreemenPrice,
    this.zpwAgreemenTime,
    this.zpwAgreemenTimeType,
    this.zpwAgreemenType,
    this.zpwCollTime,
    this.zpwCollTimeType,
    this.zpwDecreaseMoney,
    this.zpwId,
    this.zpwIosProductId,
    this.zpwIsDisposable,
    this.zpwIsIosPay,
    this.zpwIsWithdrawal,
    this.zpwIsWxPay,
    this.zpwIsZfbPay,
    this.zpwOriginalPrice,
    this.zpwPayName,
    this.zpwPrice,
    this.zpwDefaultPayKeyType,
    this.zpwDefaultZfbPayKeyType,
    this.zpwShowName,
    this.zpwVipName,
    this.zpwVipTime,
    this.zpwVipTimeType,
  });

  factory ZpwVipPriceOutput.fromRawJson(String str) => ZpwVipPriceOutput.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ZpwVipPriceOutput.fromJson(Map<String, dynamic> json) => ZpwVipPriceOutput(
    zpwAgreemenPayNum: json["agreemenPayNum"],
    zpwAgreemenPayments: json["agreemenPayments"],
    zpwAgreemenPrice: json["agreemenPrice"],
    zpwAgreemenTime: json["agreemenTime"],
    zpwAgreemenTimeType: json["agreemenTimeType"],
    zpwAgreemenType: json["agreemenType"],
    zpwCollTime: json["collTime"],
    zpwCollTimeType: json["collTimeType"],
    zpwDecreaseMoney: json["decreaseMoney"],
    zpwId: json["id"],
    zpwIosProductId: json["iosProductId"],
    zpwIsDisposable: json["isDisposable"],
    zpwIsIosPay: json["isIosPay"],
    zpwIsWithdrawal: json["isWithdrawal"],
    zpwIsWxPay: json["isWxPay"],
    zpwIsZfbPay: json["isZfbPay"],
    zpwOriginalPrice: json["originalPrice"],
    zpwPayName: json["payName"],
    zpwPrice: json["price"],
    zpwDefaultPayKeyType: json["defaultPayKeyType"],
    zpwDefaultZfbPayKeyType: json["defaultZfbPayKeyType"],
    zpwShowName: json["showName"],
    zpwVipName: json["vipName"],
    zpwVipTime: json["vipTime"],
    zpwVipTimeType: json["vipTimeType"],
  );

  Map<String, dynamic> toJson() => {
    "agreemenPayNum": zpwAgreemenPayNum,
    "agreemenPayments": zpwAgreemenPayments,
    "agreemenPrice": zpwAgreemenPrice,
    "agreemenTime": zpwAgreemenTime,
    "agreemenTimeType": zpwAgreemenTimeType,
    "agreemenType": zpwAgreemenType,
    "collTime": zpwCollTime,
    "collTimeType": zpwCollTimeType,
    "decreaseMoney": zpwDecreaseMoney,
    "id": zpwId,
    "iosProductId": zpwIosProductId,
    "isDisposable": zpwIsDisposable,
    "isIosPay": zpwIsIosPay,
    "isWithdrawal": zpwIsWithdrawal,
    "isWxPay": zpwIsWxPay,
    "isZfbPay": zpwIsZfbPay,
    "originalPrice": zpwOriginalPrice,
    "payName": zpwPayName,
    "price": zpwPrice,
    "defaultPayKeyType": zpwDefaultPayKeyType,
    "defaultZfbPayKeyType": zpwDefaultZfbPayKeyType,
    "showName": zpwShowName,
    "vipName": zpwVipName,
    "vipTime": zpwVipTime,
    "vipTimeType": zpwVipTimeType,
  };
}