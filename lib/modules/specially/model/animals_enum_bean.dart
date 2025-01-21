class AnimalsEnum {
  List<AnimalsEnumBean>? data;

  AnimalsEnum({this.data});

  AnimalsEnum.fromJson(Map<String, dynamic> json) {
    data = json["data"] == null
        ? null
        : (json["data"] as List)
            .map((e) => AnimalsEnumBean.fromJson(e))
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

class AnimalsEnumBean {
  int? index;
  String? name;
  String? value;

  AnimalsEnumBean({this.index, this.name, this.value});

  AnimalsEnumBean.fromJson(Map<String, dynamic> json) {
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
