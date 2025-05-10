class ConfigByKeyModel {
  String? configValue;

  String? configKey;

  String? configName;

  int? configId;

  ConfigByKeyModel({
    required this.configId,
    required this.configName,
    required this.configKey,
    required this.configValue,
  });

  factory ConfigByKeyModel.fromJson(dynamic json) {
    return ConfigByKeyModel(
      configId: json['configId'],
      configName: json['configName'],
      configKey: json['configKey'],
      configValue: json['configValue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'configId': configId,
      'configName': configName,
      'configKey': configKey,
      'configValue': configValue,
    };
  }
}
