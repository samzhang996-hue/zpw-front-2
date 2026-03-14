class ZpwPagePhotoGroupBind {
  ZpwPagePhotoGroupBindBean? zpwData;

  ZpwPagePhotoGroupBind({this.zpwData});

  ZpwPagePhotoGroupBind.fromJson(Map<String, dynamic> json) {
    zpwData = json["data"] == null
        ? null
        : ZpwPagePhotoGroupBindBean.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> zpwMapData = <String, dynamic>{};
    if (zpwData != null) {
      zpwMapData["data"] = zpwData?.toJson();
    }
    return zpwMapData;
  }
}

class ZpwPagePhotoGroupBindBean {
  int? zpwCurrent;
  int? zpwPages;
  List<ZpwRecords>? zpwRecords;
  int? zpwSize;
  int? zpwTotal;

  ZpwPagePhotoGroupBindBean(
      {this.zpwCurrent, this.zpwPages, this.zpwRecords, this.zpwSize, this.zpwTotal});

  ZpwPagePhotoGroupBindBean.fromJson(Map<String, dynamic> json) {
    zpwCurrent = json["current"];
    zpwPages = json["pages"];
    zpwRecords = json["records"] == null
        ? null
        : (json["records"] as List).map((e) => ZpwRecords.fromJson(e)).toList();
    zpwSize = json["size"];
    zpwTotal = json["total"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> zpwMapData = <String, dynamic>{};
    zpwMapData["current"] = zpwCurrent;
    zpwMapData["pages"] = zpwPages;
    if (zpwRecords != null) {
      zpwMapData["records"] = zpwRecords?.map((e) => e.toJson()).toList();
    }
    zpwMapData["size"] = zpwSize;
    zpwMapData["total"] = zpwTotal;
    return zpwMapData;
  }

  // 兼容旧属性名
  List<ZpwRecords>? get records => zpwRecords;
  int? get pages => zpwPages;
  int? get current => zpwCurrent;
  int? get size => zpwSize;
  int? get total => zpwTotal;
}

class ZpwRecords {
  int? zpwBindId;
  int? zpwBindType;
  ZpwPhotoFuncResp? zpwPhotoFuncResp;
  ZpwPhotoGroupResp? zpwPhotoGroupResp;

  ZpwRecords(
      {this.zpwBindId, this.zpwBindType, this.zpwPhotoFuncResp, this.zpwPhotoGroupResp});

  ZpwRecords.fromJson(Map<String, dynamic> json) {
    zpwBindId = json["bindId"];
    zpwBindType = json["bindType"];
    zpwPhotoFuncResp = json["photoFuncResp"] == null
        ? null
        : ZpwPhotoFuncResp.fromJson(json["photoFuncResp"]);
    zpwPhotoGroupResp = json["photoGroupResp"] == null
        ? null
        : ZpwPhotoGroupResp.fromJson(json["photoGroupResp"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> zpwMapData = <String, dynamic>{};
    zpwMapData["bindId"] = zpwBindId;
    zpwMapData["bindType"] = zpwBindType;
    if (zpwPhotoFuncResp != null) {
      zpwMapData["photoFuncResp"] = zpwPhotoFuncResp?.toJson();
    }
    if (zpwPhotoGroupResp != null) {
      zpwMapData["photoGroupResp"] = zpwPhotoGroupResp?.toJson();
    }
    return zpwMapData;
  }

  // 兼容旧属性名
  int? get bindId => zpwBindId;
  int? get bindType => zpwBindType;
  ZpwPhotoFuncResp? get photoFuncResp => zpwPhotoFuncResp;
  ZpwPhotoGroupResp? get photoGroupResp => zpwPhotoGroupResp;
}

class ZpwPhotoGroupResp {
  String? zpwGroupName;
  int? zpwGroupType;
  int? zpwId;
  String? zpwImgUrlAcross;
  String? zpwImgUrlVertical;
  String? zpwRemark;
  int? zpwSortNo;
  int? zpwStatus;
  int? zpwTabType;
  String? zpwTips;

  ZpwPhotoGroupResp(
      {this.zpwGroupName,
      this.zpwGroupType,
      this.zpwId,
      this.zpwImgUrlAcross,
      this.zpwImgUrlVertical,
      this.zpwRemark,
      this.zpwSortNo,
      this.zpwStatus,
      this.zpwTabType,
      this.zpwTips});

  ZpwPhotoGroupResp.fromJson(Map<String, dynamic> json) {
    zpwGroupName = json["groupName"];
    zpwGroupType = json["groupType"];
    zpwId = json["id"];
    zpwImgUrlAcross = json["imgUrlAcross"];
    zpwImgUrlVertical = json["imgUrlVertical"];
    zpwRemark = json["remark"];
    zpwSortNo = json["sortNo"];
    zpwStatus = json["status"];
    zpwTabType = json["tabType"];
    zpwTips = json["tips"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> zpwMapData = <String, dynamic>{};
    zpwMapData["groupName"] = zpwGroupName;
    zpwMapData["groupType"] = zpwGroupType;
    zpwMapData["id"] = zpwId;
    zpwMapData["imgUrlAcross"] = zpwImgUrlAcross;
    zpwMapData["imgUrlVertical"] = zpwImgUrlVertical;
    zpwMapData["remark"] = zpwRemark;
    zpwMapData["sortNo"] = zpwSortNo;
    zpwMapData["status"] = zpwStatus;
    zpwMapData["tabType"] = zpwTabType;
    zpwMapData["tips"] = zpwTips;
    return zpwMapData;
  }

  // 兼容旧属性名
  String? get groupName => zpwGroupName;
  int? get groupType => zpwGroupType;
  int? get id => zpwId;
  String? get imgUrlAcross => zpwImgUrlAcross;
  String? get imgUrlVertical => zpwImgUrlVertical;
  String? get remark => zpwRemark;
  int? get sortNo => zpwSortNo;
  int? get status => zpwStatus;
  int? get tabType => zpwTabType;
  String? get tips => zpwTips;
}

class ZpwPhotoFuncResp {
  int? zpwApiType;
  String? zpwFuncName;
  String? zpwFuncUrl;
  String? zpwFuncValue;
  String? zpwFuncValueOne;
  String? zpwFuncValueThree;
  String? zpwFuncValueTwo;
  int? zpwId;
  String? zpwRemark;
  String? zpwShowImgGif;
  String? zpwTags;
  String? zpwVideoUrl;

  ZpwPhotoFuncResp(
      {this.zpwApiType,
      this.zpwFuncName,
      this.zpwFuncUrl,
      this.zpwFuncValue,
      this.zpwFuncValueOne,
      this.zpwFuncValueThree,
      this.zpwFuncValueTwo,
      this.zpwId,
      this.zpwRemark,
      this.zpwShowImgGif,
      this.zpwTags,
      this.zpwVideoUrl});

  ZpwPhotoFuncResp.fromJson(Map<String, dynamic> json) {
    zpwApiType = json["apiType"];
    zpwFuncName = json["funcName"];
    zpwFuncUrl = json["funcUrl"];
    zpwFuncValue = json["funcValue"];
    zpwFuncValueOne = json["funcValueOne"];
    zpwFuncValueThree = json["funcValueThree"];
    zpwFuncValueTwo = json["funcValueTwo"];
    zpwId = json["id"];
    zpwRemark = json["remark"];
    zpwShowImgGif = json["showImgGif"];
    zpwTags = json["tags"];
    zpwVideoUrl = json["videoUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> zpwMapData = <String, dynamic>{};
    zpwMapData["apiType"] = zpwApiType;
    zpwMapData["funcName"] = zpwFuncName;
    zpwMapData["funcUrl"] = zpwFuncUrl;
    zpwMapData["funcValue"] = zpwFuncValue;
    zpwMapData["funcValueOne"] = zpwFuncValueOne;
    zpwMapData["funcValueThree"] = zpwFuncValueThree;
    zpwMapData["funcValueTwo"] = zpwFuncValueTwo;
    zpwMapData["id"] = zpwId;
    zpwMapData["remark"] = zpwRemark;
    zpwMapData["showImgGif"] = zpwShowImgGif;
    zpwMapData["tags"] = zpwTags;
    zpwMapData["videoUrl"] = zpwVideoUrl;
    return zpwMapData;
  }

  // 兼容旧属性名
  int? get apiType => zpwApiType;
  String? get funcName => zpwFuncName;
  String? get funcUrl => zpwFuncUrl;
  String? get funcValue => zpwFuncValue;
  String? get funcValueOne => zpwFuncValueOne;
  String? get funcValueThree => zpwFuncValueThree;
  String? get funcValueTwo => zpwFuncValueTwo;
  int? get id => zpwId;
  String? get remark => zpwRemark;
  String? get showImgGif => zpwShowImgGif;
  String? get tags => zpwTags;
  String? get videoUrl => zpwVideoUrl;
}