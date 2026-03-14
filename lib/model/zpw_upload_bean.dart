class ZpwUploadBean {
  int? zpwId;
  String? zpwMd5;
  String? zpwName;
  int? zpwImgFlag;
  String? zpwContentType;
  int? zpwSize;
  String? zpwUrl;
  int? zpwCreateId;
  String? zpwCreateTime;

  ZpwUploadBean({this.zpwId, this.zpwMd5, this.zpwName, this.zpwImgFlag, this.zpwContentType, this.zpwSize, this.zpwUrl, this.zpwCreateId, this.zpwCreateTime});

  ZpwUploadBean.fromJson(Map<String, dynamic> json) {
    zpwId = json["id"];
    zpwMd5 = json["md5"];
    zpwName = json["name"];
    zpwImgFlag = json["imgFlag"];
    zpwContentType = json["contentType"];
    zpwSize = json["size"];
    zpwUrl = json["url"];
    zpwCreateId = json["createId"];
    zpwCreateTime = json["createTime"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> zpwMapData = <String, dynamic>{};
    zpwMapData["id"] = zpwId;
    zpwMapData["md5"] = zpwMd5;
    zpwMapData["name"] = zpwName;
    zpwMapData["imgFlag"] = zpwImgFlag;
    zpwMapData["contentType"] = zpwContentType;
    zpwMapData["size"] = zpwSize;
    zpwMapData["url"] = zpwUrl;
    zpwMapData["createId"] = zpwCreateId;
    zpwMapData["createTime"] = zpwCreateTime;
    return zpwMapData;
  }

  // 兼容旧属性名
  int? get id => zpwId;
  String? get md5 => zpwMd5;
  String? get name => zpwName;
  int? get imgFlag => zpwImgFlag;
  String? get contentType => zpwContentType;
  int? get size => zpwSize;
  String? get url => zpwUrl;
  int? get createId => zpwCreateId;
  String? get createTime => zpwCreateTime;
}