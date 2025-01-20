class ListPhotoGroup {
  List<ListPhotoGroupBean>? data;

  ListPhotoGroup({this.data});

  ListPhotoGroup.fromJson(Map<String, dynamic> json) {
    data = json["data"] == null
        ? null
        : (json["data"] as List)
            .map((e) => ListPhotoGroupBean.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class ListPhotoGroupBean {
  int? id;
  int? groupType;
  String? groupName;

  String? imgUrlAcross;
  String? imgUrlVertical;
  int? tabType;
  int? status;
  int? sortNo;

  ListPhotoGroupBean(
      {this.id,
      this.groupType,
      this.groupName,
      this.imgUrlAcross,
      this.imgUrlVertical,
      this.tabType,
      this.status,
      this.sortNo});

  ListPhotoGroupBean.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    groupType = json["groupType"];
    groupName = json["groupName"];

    imgUrlAcross = json["imgUrlAcross"];
    imgUrlVertical = json["imgUrlVertical"];
    tabType = json["tabType"];
    status = json["status"];
    sortNo = json["sortNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["groupType"] = groupType;
    _data["groupName"] = groupName;

    _data["imgUrlAcross"] = imgUrlAcross;
    _data["imgUrlVertical"] = imgUrlVertical;
    _data["tabType"] = tabType;
    _data["status"] = status;
    _data["sortNo"] = sortNo;
    return _data;
  }
}
