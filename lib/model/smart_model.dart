class SmartModel {
  /// 标签,多个以逗号分隔
  final String tags;

  /// 智能体id
  final String thirdId;

  /// 智能体名称
  final String name;

  /// 智能体副标题
  final String title;

  /// 智能体图标
  final String logUrl;

  /// 功能说明
  final String description;

  SmartModel({
    required this.tags,
    required this.thirdId,
    required this.name,
    required this.title,
    required this.logUrl,
    required this.description,
  });

  factory SmartModel.fromJson(Map<String, dynamic> json) {
    return SmartModel(
      tags: json['tags'] ?? '',
      thirdId: json['thirdId'] ?? '',
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      logUrl: json['logUrl'] ?? '',
      description: json['description'] ?? '',
    );
  }

  factory SmartModel.fromParameters(Map<String, String?> json) {
    return SmartModel(
      tags: '',
      thirdId: json['image'] ?? '',
      title: json['subTitle'] ?? '',
      name: json['title'] ?? '',
      logUrl: json['logo'] ?? '',
      description: json['cta'] ?? '',
    );
  }

  static List<SmartModel> fromJsonList(dynamic jsonList) {
    return (jsonList as List).map((json) => SmartModel.fromJson(json)).toList();
  }

  Map<String, String> toMap() {
    return {
      'title': name,
      'subTitle': title,
      'logo': logUrl,
      'url': '',
      'cta': description,
      'image': thirdId,
      'category': '',
    };
  }
}
