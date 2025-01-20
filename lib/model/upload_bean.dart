
class UploadBean {
  int? id;
  String? md5;
  String? name;
  int? imgFlag;
  String? contentType;
  int? size;
  String? url;
  int? createId;
  String? createTime;

  UploadBean({this.id, this.md5, this.name, this.imgFlag, this.contentType, this.size, this.url, this.createId, this.createTime});

  UploadBean.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    md5 = json["md5"];
    name = json["name"];
    imgFlag = json["imgFlag"];
    contentType = json["contentType"];
    size = json["size"];
    url = json["url"];
    createId = json["createId"];
    createTime = json["createTime"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["md5"] = md5;
    _data["name"] = name;
    _data["imgFlag"] = imgFlag;
    _data["contentType"] = contentType;
    _data["size"] = size;
    _data["url"] = url;
    _data["createId"] = createId;
    _data["createTime"] = createTime;
    return _data;
  }
}