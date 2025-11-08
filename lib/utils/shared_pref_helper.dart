import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static final SharedPrefHelper _instance = SharedPrefHelper._internal();
  static SharedPreferences? _preferences;

  factory SharedPrefHelper() {
    return _instance;
  }

  SharedPrefHelper._internal();

  /// Initialize SharedPreferences (must be called in main before using)
  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  /// Save a boolean value
  Future<void> setBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  /// Retrieve a boolean value (default: false)
  bool getBool(String key, {bool defaultValue = false}) {
    return _preferences?.getBool(key) ?? defaultValue;
  }

  /// Save a string value
  Future<void> setString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  /// Retrieve a string value (default: empty string)
  String getString(String key, {String defaultValue = ""}) {
    return _preferences?.getString(key) ?? defaultValue;
  }

  /// Save an integer value
  Future<void> setInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  /// Retrieve an integer value (default: 0)
  int getInt(String key, {int defaultValue = 0}) {
    return _preferences?.getInt(key) ?? defaultValue;
  }

  /// Save a double value
  Future<void> setDouble(String key, double value) async {
    await _preferences?.setDouble(key, value);
  }

  /// Retrieve a double value (default: 0.0)
  double getDouble(String key, {double defaultValue = 0.0}) {
    return _preferences?.getDouble(key) ?? defaultValue;
  }

  /// Save a list of strings
  Future<void> setStringList(String key, List<String> value) async {
    await _preferences?.setStringList(key, value);
  }

  /// Retrieve a list of strings (default: empty list)
  List<String> getStringList(
    String key, {
    List<String> defaultValue = const [],
  }) {
    return _preferences?.getStringList(key) ?? defaultValue;
  }

  /// Remove a key from SharedPreferences
  Future<void> remove(String key) async {
    await _preferences?.remove(key);
  }

  /// Clear all SharedPreferences data
  Future<void> clear() async {
    await _preferences?.clear();
  }
}
