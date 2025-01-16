import 'dart:convert';

class VipBean {
  String? channel;
  List<PList>? contentPopList;
  String? createTime;
  List<PList>? homePopList;
  int? id;
  List<PList>? otherPopList;
  int? projectId;
  List<PList>? vipList;
  List<PList>? vipPopList;

  VipBean({
    this.channel,
    this.contentPopList,
    this.createTime,
    this.homePopList,
    this.id,
    this.otherPopList,
    this.projectId,
    this.vipList,
    this.vipPopList,
  });

  factory VipBean.fromRawJson(String str) => VipBean.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VipBean.fromJson(Map<String, dynamic> json) => VipBean(
    channel: json["channel"],
    contentPopList: json["contentPopList"] == null ? [] : List<PList>.from(json["contentPopList"]!.map((x) => PList.fromJson(x))),
    createTime: json["createTime"] ,
    homePopList: json["homePopList"] == null ? [] : List<PList>.from(json["homePopList"]!.map((x) =>  PList.fromJson(x))),
    id: json["id"],
    otherPopList: json["otherPopList"] == null ? [] : List<PList>.from(json["otherPopList"]!.map((x) => PList.fromJson(x))),
    projectId: json["projectId"],
    vipList: json["vipList"] == null ? [] : List<PList>.from(json["vipList"]!.map((x) => PList.fromJson(x))),
    vipPopList: json["vipPopList"] == null ? [] : List<PList>.from(json["vipPopList"]!.map((x) =>  PList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "channel": channel,
    "contentPopList": contentPopList == null ? [] : List<dynamic>.from(contentPopList!.map((x) => x.toJson())),
    "createTime": createTime,
    "homePopList": homePopList == null ? [] : List<dynamic>.from(homePopList!.map((x) => x.toJson())),
    "id": id,
    "otherPopList": otherPopList == null ? [] : List<dynamic>.from(otherPopList!.map((x) => x.toJson())),
    "projectId": projectId,
    "vipList": vipList == null ? [] : List<dynamic>.from(vipList!.map((x) => x.toJson())),
    "vipPopList": vipPopList == null ? [] : List<dynamic>.from(vipPopList!.map((x) => x.toJson())),
  };
}

class PList {
  dynamic isPayOne;
  String? remark1;
  String? remark10;
  String? remark2;
  String? remark3;
  String? remark4;
  String? remark5;
  String? remark6;
  String? remark7;
  String? remark8;
  String? remark9;
  String? showRemark;
  int? sortId;
  int? vipPriceId;
  VipPriceOutput? vipPriceOutput;

  PList({
    this.isPayOne,
    this.remark1,
    this.remark10,
    this.remark2,
    this.remark3,
    this.remark4,
    this.remark5,
    this.remark6,
    this.remark7,
    this.remark8,
    this.remark9,
    this.showRemark,
    this.sortId,
    this.vipPriceId,
    this.vipPriceOutput,
  });

  factory PList.fromRawJson(String str) => PList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PList.fromJson(Map<String, dynamic> json) => PList(
    isPayOne: json["isPayOne"],
    remark1: json["remark1"],
    remark10: json["remark10"],
    remark2: json["remark2"],
    remark3: json["remark3"],
    remark4: json["remark4"],
    remark5: json["remark5"],
    remark6: json["remark6"],
    remark7: json["remark7"],
    remark8: json["remark8"],
    remark9: json["remark9"],
    showRemark: json["showRemark"],
    sortId: json["sortId"],
    vipPriceId: json["vipPriceId"],
    vipPriceOutput: json["vipPriceOutput"] == null ? null : VipPriceOutput.fromJson(json["vipPriceOutput"]),
  );

  Map<String, dynamic> toJson() => {
    "isPayOne": isPayOne,
    "remark1": remark1,
    "remark10": remark10,
    "remark2": remark2,
    "remark3": remark3,
    "remark4": remark4,
    "remark5": remark5,
    "remark6": remark6,
    "remark7": remark7,
    "remark8": remark8,
    "remark9": remark9,
    "showRemark": showRemark,
    "sortId": sortId,
    "vipPriceId": vipPriceId,
    "vipPriceOutput": vipPriceOutput?.toJson(),
  };
}

class VipPriceOutput {
  int? agreemenPayNum;
  int? agreemenPayments;
  int? agreemenPrice;
  int? agreemenTime;
  String? agreemenTimeType;
  int? agreemenType;
  int? collTime;
  String? collTimeType;
  int? decreaseMoney;
  int? id;
  dynamic iosProductId;
  int? isDisposable;
  int? isIosPay;
  int? isWithdrawal;
  int? isWxPay;
  int? isZfbPay;
  int? originalPrice;
  String? payName;
  int? price;
  int? defaultPayKeyType;
  int? defaultZfbPayKeyType;
  String? showName;
  String? vipName;
  int? vipTime;
  String? vipTimeType;

  VipPriceOutput({
    this.agreemenPayNum,
    this.agreemenPayments,
    this.agreemenPrice,
    this.agreemenTime,
    this.agreemenTimeType,
    this.agreemenType,
    this.collTime,
    this.collTimeType,
    this.decreaseMoney,
    this.id,
    this.iosProductId,
    this.isDisposable,
    this.isIosPay,
    this.isWithdrawal,
    this.isWxPay,
    this.isZfbPay,
    this.originalPrice,
    this.payName,
    this.price,
    this.defaultPayKeyType,
    this.defaultZfbPayKeyType,
    this.showName,
    this.vipName,
    this.vipTime,
    this.vipTimeType,
  });

  factory VipPriceOutput.fromRawJson(String str) => VipPriceOutput.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VipPriceOutput.fromJson(Map<String, dynamic> json) => VipPriceOutput(
    agreemenPayNum: json["agreemenPayNum"],
    agreemenPayments: json["agreemenPayments"],
    agreemenPrice: json["agreemenPrice"],
    agreemenTime: json["agreemenTime"],
    agreemenTimeType: json["agreemenTimeType"],
    agreemenType: json["agreemenType"],
    collTime: json["collTime"],
    collTimeType: json["collTimeType"],
    decreaseMoney: json["decreaseMoney"],
    id: json["id"],
    iosProductId: json["iosProductId"],
    isDisposable: json["isDisposable"],
    isIosPay: json["isIosPay"],
    isWithdrawal: json["isWithdrawal"],
    isWxPay: json["isWxPay"],
    isZfbPay: json["isZfbPay"],
    originalPrice: json["originalPrice"],
    payName: json["payName"],
    price: json["price"],
    defaultPayKeyType: json["defaultPayKeyType"],
    defaultZfbPayKeyType: json["defaultZfbPayKeyType"],
    showName: json["showName"],
    vipName: json["vipName"],
    vipTime: json["vipTime"],
    vipTimeType: json["vipTimeType"],
  );

  Map<String, dynamic> toJson() => {
    "agreemenPayNum": agreemenPayNum,
    "agreemenPayments": agreemenPayments,
    "agreemenPrice": agreemenPrice,
    "agreemenTime": agreemenTime,
    "agreemenTimeType": agreemenTimeType,
    "agreemenType": agreemenType,
    "collTime": collTime,
    "collTimeType": collTimeType,
    "decreaseMoney": decreaseMoney,
    "id": id,
    "iosProductId": iosProductId,
    "isDisposable": isDisposable,
    "isIosPay": isIosPay,
    "isWithdrawal": isWithdrawal,
    "isWxPay": isWxPay,
    "isZfbPay": isZfbPay,
    "originalPrice": originalPrice,
    "payName": payName,
    "price": price,
    "defaultPayKeyType": defaultPayKeyType,
    "defaultZfbPayKeyType": defaultZfbPayKeyType,
    "showName": showName,
    "vipName": vipName,
    "vipTime": vipTime,
    "vipTimeType": vipTimeType,
  };
}
