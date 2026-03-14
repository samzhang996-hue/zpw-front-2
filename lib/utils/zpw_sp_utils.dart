import 'package:shared_preferences/shared_preferences.dart';
class ZpwSpUtils {
  static SharedPreferences? _zpwPreferences;

  static Future<void> _init() async {
    _zpwPreferences ??= await SharedPreferences.getInstance();
  }

  //
  // void setData<T>(String key, T data) {
  //   if (data is String) {
  //     _zpwPreferences?.setString(key, data);
  //   } else if (data is double) {
  //     _zpwPreferences?.setDouble(key, data);
  //   } else if (data is int) {
  //     _zpwPreferences?.setInt(key, data);
  //   } else if (data is bool) {
  //     _zpwPreferences?.setBool(key, data);
  //   } else if (data is List<String>) {
  //     _zpwPreferences?.setStringList(key, data);
  //   }
  // }
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    await _init();
    return _zpwPreferences!.getBool(key) ?? defaultValue;
  }

  static Future<void> setBool(String key, bool value) async {
    await _init();
    await _zpwPreferences!.setBool(key, value);
  }

  static Future<int> getInt(String key, {int defaultValue = 0}) async {
    await _init();
    return _zpwPreferences!.getInt(key) ?? defaultValue;
  }

  static Future<void> setInt(String key, int value) async {
    await _init();
    await _zpwPreferences!.setInt(key, value);
  }

  static Future<String> getString(String key,
      {String defaultValue = ''}) async {
    await _init();
    return _zpwPreferences!.getString(key) ?? defaultValue;
  }

  static Future<void> setString(String key, String value) async {
    await _init();
    await _zpwPreferences!.setString(key, value);
  }

  // 添加其他类型（如List、double等）的读写方法，类似上述示例

  static Future<void> remove(String key) async {
    await _init();
    await _zpwPreferences!.remove(key);
  }

  static Future<void> clear() async {
    await _init();
    await _zpwPreferences!.clear();
  }
}