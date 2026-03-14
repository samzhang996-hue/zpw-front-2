class ZpwListPhotoGroup {
  List<ZpwListPhotoGroupBean>? zpwData;

  ZpwListPhotoGroup({this.zpwData});

  ZpwListPhotoGroup.fromJson(Map<String, dynamic> json) {
    zpwData = json["data"] == null
        ? null
        : (json["data"] as List)
            .map((e) => ZpwListPhotoGroupBean.fromJson(e))
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

class ZpwListPhotoGroupBean {
  int? zpwId;
  int? zpwGroupType;
  String? zpwGroupName;
  String? zpwTips;
  String? zpwFrontType;

  String? zpwImgUrlAcross;
  String? zpwImgUrlVertical;
  int? zpwTabType;
  int? zpwStatus;
  int? zpwSortNo;

  ZpwListPhotoGroupBean(
      {this.zpwId,
      this.zpwGroupType,
      this.zpwGroupName,
      this.zpwTips,
      this.zpwFrontType,
      this.zpwImgUrlAcross,
      this.zpwImgUrlVertical,
      this.zpwTabType,
      this.zpwStatus,
      this.zpwSortNo});

  ZpwListPhotoGroupBean.fromJson(Map<String, dynamic> json) {
    zpwId = json["id"];
    zpwGroupType = json["groupType"];
    zpwGroupName = json["groupName"];
    zpwTips = json["tips"];
    zpwFrontType = json["frontType"];

    zpwImgUrlAcross = json["imgUrlAcross"];
    zpwImgUrlVertical = json["imgUrlVertical"];
    zpwTabType = json["tabType"];
    zpwStatus = json["status"];
    zpwSortNo = json["sortNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> zpwMapData = <String, dynamic>{};
    zpwMapData["id"] = zpwId;
    zpwMapData["groupType"] = zpwGroupType;
    zpwMapData["groupName"] = zpwGroupName;
    zpwMapData["tips"] = zpwTips;
    zpwMapData["frontType"] = zpwFrontType;

    zpwMapData["imgUrlAcross"] = zpwImgUrlAcross;
    zpwMapData["imgUrlVertical"] = zpwImgUrlVertical;
    zpwMapData["tabType"] = zpwTabType;
    zpwMapData["status"] = zpwStatus;
    zpwMapData["sortNo"] = zpwSortNo;
    return zpwMapData;
  }

  // 兼容旧属性名
  int? get id => zpwId;
  int? get groupType => zpwGroupType;
  String? get groupName => zpwGroupName;
  String? get tips => zpwTips;
  String? get frontType => zpwFrontType;
  String? get imgUrlAcross => zpwImgUrlAcross;
  String? get imgUrlVertical => zpwImgUrlVertical;
  int? get tabType => zpwTabType;
  int? get status => zpwStatus;
  int? get sortNo => zpwSortNo;
}