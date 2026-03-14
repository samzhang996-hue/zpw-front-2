class ZpwCommEnum {
  List<ZpwCommEnumBean>? data;

  ZpwCommEnum({this.data});

  ZpwCommEnum.fromJson(Map<String, dynamic> json) {
    data = json["data"] == null
        ? null
        : (json["data"] as List).map((e) => ZpwCommEnumBean.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class ZpwCommEnumBean {
  int? index;
  String? name;
  String? value;

  ZpwCommEnumBean({this.index, this.name, this.value});

  ZpwCommEnumBean.fromJson(Map<String, dynamic> json) {
    index = json["index"];
    name = json["name"];
    value = json["value"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["index"] = index;
    _data["name"] = name;
    _data["value"] = value;
    return _data;
  }
}
