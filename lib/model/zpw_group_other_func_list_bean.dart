class ZpwGroupOtherFuncList {
  List<ZpwGroupOtherFuncListBean>? zpwData;

  ZpwGroupOtherFuncList({this.zpwData});

  ZpwGroupOtherFuncList.fromJson(Map<String, dynamic> json) {
    zpwData = json["data"] == null
        ? null
        : (json["data"] as List)
            .map((e) => ZpwGroupOtherFuncListBean.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> zpwMapData = <String, dynamic>{};
    if (zpwData != null) {
      zpwMapData["data"] = zpwData?.map((e) => e.toJson()).toList();
    }
    return zpwMapData;
  }
}

class ZpwGroupOtherFuncListBean {
  int? zpwApiType;
  String? zpwApiTypeName;
  ZpwCategoryResp? zpwCategoryResp;
  String? zpwCreateTime;
  String? zpwFuncName;
  String? zpwFuncValue;
  String? zpwFuncValueOne;
  String? zpwFuncValueThree;
  String? zpwFuncValueTwo;
  ZpwGroupBackResp? zpwGroupBackResp;
  int? zpwId;
  String? zpwRemark;
  String? zpwShowImgGif;
  int? zpwSortNo;
  int? zpwStatus;
  String? zpwTags;
  String? zpwVideoUrl;

  ZpwGroupOtherFuncListBean(
      {this.zpwApiType,
      this.zpwApiTypeName,
      this.zpwCategoryResp,
      this.zpwCreateTime,
      this.zpwFuncName,
      this.zpwFuncValue,
      this.zpwFuncValueOne,
      this.zpwFuncValueThree,
      this.zpwFuncValueTwo,
      this.zpwGroupBackResp,
      this.zpwId,
      this.zpwRemark,
      this.zpwShowImgGif,
      this.zpwSortNo,
      this.zpwStatus,
      this.zpwTags,
      this.zpwVideoUrl});

  ZpwGroupOtherFuncListBean.fromJson(Map<String, dynamic> json) {
    zpwApiType = json["apiType"];
    zpwApiTypeName = json["apiTypeName"];
    zpwCategoryResp = json["categoryResp"] == null
        ? null
        : ZpwCategoryResp.fromJson(json["categoryResp"]);
    zpwCreateTime = json["createTime"];
    zpwFuncName = json["funcName"];
    zpwFuncValue = json["funcValue"];
    zpwFuncValueOne = json["funcValueOne"];
    zpwFuncValueThree = json["funcValueThree"];
    zpwFuncValueTwo = json["funcValueTwo"];
    zpwGroupBackResp = json["groupBackResp"] == null
        ? null
        : ZpwGroupBackResp.fromJson(json["groupBackResp"]);
    zpwId = json["id"];
    zpwRemark = json["remark"];
    zpwShowImgGif = json["showImgGif"];
    zpwSortNo = json["sortNo"];
    zpwStatus = json["status"];
    zpwTags = json["tags"];
    zpwVideoUrl = json["videoUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> zpwMapData = <String, dynamic>{};
    zpwMapData["apiType"] = zpwApiType;
    zpwMapData["apiTypeName"] = zpwApiTypeName;
    if (zpwCategoryResp != null) {
      zpwMapData["categoryResp"] = zpwCategoryResp?.toJson();
    }
    zpwMapData["createTime"] = zpwCreateTime;
    zpwMapData["funcName"] = zpwFuncName;
    zpwMapData["funcValue"] = zpwFuncValue;
    zpwMapData["funcValueOne"] = zpwFuncValueOne;
    zpwMapData["funcValueThree"] = zpwFuncValueThree;
    zpwMapData["funcValueTwo"] = zpwFuncValueTwo;
    if (zpwGroupBackResp != null) {
      zpwMapData["groupBackResp"] = zpwGroupBackResp?.toJson();
    }
    zpwMapData["id"] = zpwId;
    zpwMapData["remark"] = zpwRemark;
    zpwMapData["showImgGif"] = zpwShowImgGif;
    zpwMapData["sortNo"] = zpwSortNo;
    zpwMapData["status"] = zpwStatus;
    zpwMapData["tags"] = zpwTags;
    zpwMapData["videoUrl"] = zpwVideoUrl;
    return zpwMapData;
  }

  // 兼容旧属性名
  int? get apiType => zpwApiType;
  String? get apiTypeName => zpwApiTypeName;
  ZpwCategoryResp? get categoryResp => zpwCategoryResp;
  String? get createTime => zpwCreateTime;
  String? get funcName => zpwFuncName;
  String? get funcValue => zpwFuncValue;
  String? get funcValueOne => zpwFuncValueOne;
  String? get funcValueThree => zpwFuncValueThree;
  String? get funcValueTwo => zpwFuncValueTwo;
  ZpwGroupBackResp? get groupBackResp => zpwGroupBackResp;
  int? get id => zpwId;
  String? get remark => zpwRemark;
  String? get showImgGif => zpwShowImgGif;
  int? get sortNo => zpwSortNo;
  int? get status => zpwStatus;
  String? get tags => zpwTags;
  String? get videoUrl => zpwVideoUrl;
}

class ZpwGroupBackResp {
  int? zpwGroupId;
  String? zpwGroupName;
  int? zpwSortNo;

  ZpwGroupBackResp({this.zpwGroupId, this.zpwGroupName, this.zpwSortNo});

  ZpwGroupBackResp.fromJson(Map<String, dynamic> json) {
    zpwGroupId = json["groupId"];
    zpwGroupName = json["groupName"];
    zpwSortNo = json["sortNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> zpwMapData = <String, dynamic>{};
    zpwMapData["groupId"] = zpwGroupId;
    zpwMapData["groupName"] = zpwGroupName;
    zpwMapData["sortNo"] = zpwSortNo;
    return zpwMapData;
  }
}

class ZpwCategoryResp {
  int? zpwGroupId;
  String? zpwGroupName;
  int? zpwSortNo;

  ZpwCategoryResp({this.zpwGroupId, this.zpwGroupName, this.zpwSortNo});

  ZpwCategoryResp.fromJson(Map<String, dynamic> json) {
    zpwGroupId = json["groupId"];
    zpwGroupName = json["groupName"];
    zpwSortNo = json["sortNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> zpwMapData = <String, dynamic>{};
    zpwMapData["groupId"] = zpwGroupId;
    zpwMapData["groupName"] = zpwGroupName;
    zpwMapData["sortNo"] = zpwSortNo;
    return zpwMapData;
  }
}