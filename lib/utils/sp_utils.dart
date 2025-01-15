import 'package:shared_preferences/shared_preferences.dart';
class SpUtils {
  static SharedPreferences? _preferences;

  static Future<void> _init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  //
  // void setData<T>(String key, T data) {
  //   if (data is String) {
  //     _preferences?.setString(key, data);
  //   } else if (data is double) {
  //     _preferences?.setDouble(key, data);
  //   } else if (data is int) {
  //     _preferences?.setInt(key, data);
  //   } else if (data is bool) {
  //     _preferences?.setBool(key, data);
  //   } else if (data is List<String>) {
  //     _preferences?.setStringList(key, data);
  //   }
  // }
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    await _init();
    return _preferences!.getBool(key) ?? defaultValue;
  }

  static Future<void> setBool(String key, bool value) async {
    await _init();
    await _preferences!.setBool(key, value);
  }

  static Future<int> getInt(String key, {int defaultValue = 0}) async {
    await _init();
    return _preferences!.getInt(key) ?? defaultValue;
  }

  static Future<void> setInt(String key, int value) async {
    await _init();
    await _preferences!.setInt(key, value);
  }

  static Future<String> getString(String key,
      {String defaultValue = ''}) async {
    await _init();
    return _preferences!.getString(key) ?? defaultValue;
  }

  static Future<void> setString(String key, String value) async {
    await _init();
    await _preferences!.setString(key, value);
  }

  // 添加其他类型（如List、double等）的读写方法，类似上述示例

  static Future<void> remove(String key) async {
    await _init();
    await _preferences!.remove(key);
  }

  static Future<void> clear() async {
    await _init();
    await _preferences!.clear();
  }
}
