class GroupOtherFuncList {
  List<GroupOtherFuncListBean>? data;

  GroupOtherFuncList({this.data});

  GroupOtherFuncList.fromJson(Map<String, dynamic> json) {
    data = json["data"] == null
        ? null
        : (json["data"] as List)
            .map((e) => GroupOtherFuncListBean.fromJson(e))
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

class GroupOtherFuncListBean {
  int? apiType;
  String? apiTypeName;
  CategoryResp? categoryResp;
  String? createTime;
  String? funcName;
  String? funcValue;
  String? funcValueOne;
  String? funcValueThree;
  String? funcValueTwo;
  GroupBackResp? groupBackResp;
  int? id;
  String? remark;
  String? showImgGif;
  int? sortNo;
  int? status;
  String? tags;
  String? videoUrl;

  GroupOtherFuncListBean(
      {this.apiType,
      this.apiTypeName,
      this.categoryResp,
      this.createTime,
      this.funcName,
      this.funcValue,
      this.funcValueOne,
      this.funcValueThree,
      this.funcValueTwo,
      this.groupBackResp,
      this.id,
      this.remark,
      this.showImgGif,
      this.sortNo,
      this.status,
      this.tags,
      this.videoUrl});

  GroupOtherFuncListBean.fromJson(Map<String, dynamic> json) {
    apiType = json["apiType"];
    apiTypeName = json["apiTypeName"];
    categoryResp = json["categoryResp"] == null
        ? null
        : CategoryResp.fromJson(json["categoryResp"]);
    createTime = json["createTime"];
    funcName = json["funcName"];
    funcValue = json["funcValue"];
    funcValueOne = json["funcValueOne"];
    funcValueThree = json["funcValueThree"];
    funcValueTwo = json["funcValueTwo"];
    groupBackResp = json["groupBackResp"] == null
        ? null
        : GroupBackResp.fromJson(json["groupBackResp"]);
    id = json["id"];
    remark = json["remark"];
    showImgGif = json["showImgGif"];
    sortNo = json["sortNo"];
    status = json["status"];
    tags = json["tags"];
    videoUrl = json["videoUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["apiType"] = apiType;
    _data["apiTypeName"] = apiTypeName;
    if (categoryResp != null) {
      _data["categoryResp"] = categoryResp?.toJson();
    }
    _data["createTime"] = createTime;
    _data["funcName"] = funcName;
    _data["funcValue"] = funcValue;
    _data["funcValueOne"] = funcValueOne;
    _data["funcValueThree"] = funcValueThree;
    _data["funcValueTwo"] = funcValueTwo;
    if (groupBackResp != null) {
      _data["groupBackResp"] = groupBackResp?.toJson();
    }
    _data["id"] = id;
    _data["remark"] = remark;
    _data["showImgGif"] = showImgGif;
    _data["sortNo"] = sortNo;
    _data["status"] = status;
    _data["tags"] = tags;
    _data["videoUrl"] = videoUrl;
    return _data;
  }
}

class GroupBackResp {
  int? groupId;
  String? groupName;
  int? sortNo;

  GroupBackResp({this.groupId, this.groupName, this.sortNo});

  GroupBackResp.fromJson(Map<String, dynamic> json) {
    groupId = json["groupId"];
    groupName = json["groupName"];
    sortNo = json["sortNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["groupId"] = groupId;
    _data["groupName"] = groupName;
    _data["sortNo"] = sortNo;
    return _data;
  }
}

class CategoryResp {
  int? groupId;
  String? groupName;
  int? sortNo;

  CategoryResp({this.groupId, this.groupName, this.sortNo});

  CategoryResp.fromJson(Map<String, dynamic> json) {
    groupId = json["groupId"];
    groupName = json["groupName"];
    sortNo = json["sortNo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["groupId"] = groupId;
    _data["groupName"] = groupName;
    _data["sortNo"] = sortNo;
    return _data;
  }
}
