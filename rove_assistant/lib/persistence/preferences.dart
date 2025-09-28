import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences extends ChangeNotifier {
  static late final SharedPreferencesWithCache _prefs;

  Preferences._privateConstructor();

  static final Preferences _instance = Preferences._privateConstructor();

  static Preferences get instance => _instance;

  final Map<String, String?> _defaults = {};

  static SharedPreferencesWithCache get silentPrefs => _prefs;

  String? getString(String key) {
    return _prefs.getString(key) ?? _defaults[key];
  }

  void setString(String key, String? value) {
    if (value != null) {
      _prefs.setString(key, value);
    } else {
      _prefs.remove(key);
    }
    notifyListeners();
  }

  void addDefaults(Map<String, String?> defaults) {
    _defaults.addAll(defaults);
    notifyListeners();
  }

  static Future<SharedPreferencesWithCache> init() async =>
      _prefs = await SharedPreferencesWithCache.create(
          cacheOptions: SharedPreferencesWithCacheOptions());
}
