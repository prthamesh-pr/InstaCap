import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'dart:convert';

class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();

  StorageService._();

  late SharedPreferences _prefs;
  late Box _hiveBox;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _hiveBox = await Hive.openBox('app_storage');
  }

  // Shared Preferences methods
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  Future<void> setStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  // Hive methods for complex objects
  Future<void> saveObject(String key, Map<String, dynamic> object) async {
    await _hiveBox.put(key, json.encode(object));
  }

  Map<String, dynamic>? getObject(String key) {
    final jsonString = _hiveBox.get(key);
    if (jsonString != null) {
      return json.decode(jsonString);
    }
    return null;
  }

  Future<void> saveList(String key, List<Map<String, dynamic>> list) async {
    final jsonString = json.encode(list);
    await _hiveBox.put(key, jsonString);
  }

  List<Map<String, dynamic>>? getList(String key) {
    final jsonString = _hiveBox.get(key);
    if (jsonString != null) {
      final List<dynamic> decodedList = json.decode(jsonString);
      return decodedList.cast<Map<String, dynamic>>();
    }
    return null;
  }

  Future<void> deleteObject(String key) async {
    await _hiveBox.delete(key);
  }

  // User-specific storage
  Future<void> saveUserData(
      String userId, Map<String, dynamic> userData) async {
    await saveObject('user_$userId', userData);
  }

  Map<String, dynamic>? getUserData(String userId) {
    return getObject('user_$userId');
  }

  Future<void> clearUserData() async {
    final keys = _hiveBox.keys
        .where((key) => key.toString().startsWith('user_'))
        .toList();
    for (final key in keys) {
      await _hiveBox.delete(key);
    }

    // Also clear shared preferences user-related data
    await _prefs.remove('current_user_id');
    await _prefs.remove('is_first_time');
  }

  Future<void> clearAll() async {
    await _prefs.clear();
    await _hiveBox.clear();
  }
}
