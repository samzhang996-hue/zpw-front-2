import 'dart:math';

class PagePhotoGroupBind {
  PagePhotoGroupBindBean? data;

  PagePhotoGroupBind({this.data});

  PagePhotoGroupBind.fromJson(Map<String, dynamic> json) {
    data = json["data"] == null ? null : PagePhotoGroupBindBean.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class PagePhotoGroupBindBean {
  int? current;
  int? pages;
  List<Records>? records;
  int? size;
  int? total;

  PagePhotoGroupBindBean({this.current, this.pages, this.records, this.size, this.total});

  PagePhotoGroupBindBean.fromJson(Map<String, dynamic> json) {
    current = json["current"];
    pages = json["pages"];
    records = json["records"] == null ? null : (json["records"] as List).map((e) => Records.fromJson(e)).toList();
    size = json["size"];
    total = json["total"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["current"] = current;
    _data["pages"] = pages;
    if (records != null) {
      _data["records"] = records?.map((e) => e.toJson()).toList();
    }
    _data["size"] = size;
    _data["total"] = total;
    return _data;
  }
}

class Records {
  int? bindId;
  int? bindType;
  PhotoFuncResp? photoFuncResp;
  PhotoGroupResp? photoGroupResp;
  // double height = 0;
  Records({this.bindId, this.bindType, this.photoFuncResp, this.photoGroupResp});

  Records.fromJson(Map<String, dynamic> json) {
    bindId = json["bindId"];
    bindType = json["bindType"];
    photoFuncResp = json["photoFuncResp"] == null ? null : PhotoFuncResp.fromJson(json["photoFuncResp"]);
    photoGroupResp = json["photoGroupResp"] == null ? null : PhotoGroupResp.fromJson(json["photoGroupResp"]);
    // height = 20 + (Random().nextDouble() * (60 - 20));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["bindId"] = bindId;
    _data["bindType"] = bindType;
    if (photoFuncResp != null) {
      _data["photoFuncResp"] = photoFuncResp?.toJson();
    }
    if (photoGroupResp != null) {
      _data["photoGroupResp"] = photoGroupResp?.toJson();
    }
    return _data;
  }
}

class PhotoGroupResp {
  String? groupName;
  int? groupType;
  int? id;
  String? imgUrlAcross;
  String? imgUrlVertical;
  String? remark;
  int? sortNo;
  int? status;
  int? tabType;
  String? tips;
  int? hot;
  String? hotW;

  PhotoGroupResp({
    this.groupName,
    this.groupType,
    this.id,
    this.imgUrlAcross,
    this.imgUrlVertical,
    this.remark,
    this.sortNo,
    this.status,
    this.tabType,
    this.tips,
    this.hot,
    this.hotW,
  });

  PhotoGroupResp.fromJson(Map<String, dynamic> json) {
    groupName = json["groupName"];
    groupType = json["groupType"];
    id = json["id"];
    imgUrlAcross = json["imgUrlAcross"];
    imgUrlVertical = json["imgUrlVertical"];
    remark = json["remark"];
    sortNo = json["sortNo"];
    status = json["status"];
    tabType = json["tabType"];
    tips = json["tips"];
    hot = 1500 + Random().nextInt(6000 - 1500 + 1);
    hotW = (1.5 + (Random().nextDouble() * (3.2 - 1.5))).toStringAsFixed(1);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["groupName"] = groupName;
    _data["groupType"] = groupType;
    _data["id"] = id;
    _data["imgUrlAcross"] = imgUrlAcross;
    _data["imgUrlVertical"] = imgUrlVertical;
    _data["remark"] = remark;
    _data["sortNo"] = sortNo;
    _data["status"] = status;
    _data["tabType"] = tabType;
    _data["tips"] = tips;
    return _data;
  }
}

class PhotoFuncResp {
  int? apiType;
  String? funcName;
  String? funcUrl;
  String? funcValue;
  String? funcValueOne;
  String? funcValueThree;
  String? funcValueTwo;
  int? id;
  String? remark;
  String? showImgGif;
  String? tags;
  String? videoUrl;
  int? hot;
  String? hotW;

  PhotoFuncResp({
    this.apiType,
    this.funcName,
    this.funcUrl,
    this.funcValue,
    this.funcValueOne,
    this.funcValueThree,
    this.funcValueTwo,
    this.id,
    this.remark,
    this.showImgGif,
    this.tags,
    this.videoUrl,
    this.hot,
    this.hotW,
  });

  PhotoFuncResp.fromJson(Map<String, dynamic> json) {
    apiType = json["apiType"];
    funcName = json["funcName"];
    funcUrl = json["funcUrl"];
    funcValue = json["funcValue"];
    funcValueOne = json["funcValueOne"];
    funcValueThree = json["funcValueThree"];
    funcValueTwo = json["funcValueTwo"];
    id = json["id"];
    remark = json["remark"];
    showImgGif = json["showImgGif"];
    tags = json["tags"];
    videoUrl = json["videoUrl"];
    hot = 1500 + Random().nextInt(6000 - 1500 + 1);
    hotW = (1.5 + (Random().nextDouble() * (3.2 - 1.5))).toStringAsFixed(1);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["apiType"] = apiType;
    _data["funcName"] = funcName;
    _data["funcUrl"] = funcUrl;
    _data["funcValue"] = funcValue;
    _data["funcValueOne"] = funcValueOne;
    _data["funcValueThree"] = funcValueThree;
    _data["funcValueTwo"] = funcValueTwo;
    _data["id"] = id;
    _data["remark"] = remark;
    _data["showImgGif"] = showImgGif;
    _data["tags"] = tags;
    _data["videoUrl"] = videoUrl;
    return _data;
  }
}
