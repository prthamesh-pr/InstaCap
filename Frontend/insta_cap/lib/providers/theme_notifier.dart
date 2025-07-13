import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  static const String _isDarkModeKey = 'isDarkMode';
  
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeNotifier() {
    _loadThemeFromPrefs();
  }

  /// Load theme preference from SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_isDarkModeKey) ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _saveThemeToPrefs();
    notifyListeners();
  }

  /// Set a specific theme mode
  Future<void> setThemeMode(bool isDark) async {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      await _saveThemeToPrefs();
      notifyListeners();
    }
  }

  /// Save theme preference to SharedPreferences
  Future<void> _saveThemeToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isDarkModeKey, _isDarkMode);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  /// Get appropriate text color based on current theme
  Color getTextColor({bool primary = true}) {
    if (_isDarkMode) {
      return primary ? Colors.white : Colors.white70;
    } else {
      return primary ? const Color(0xFF1A1A1A) : const Color(0xFF757575);
    }
  }

  /// Get appropriate surface color based on current theme
  Color getSurfaceColor() {
    return _isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  }

  /// Get appropriate background color based on current theme
  Color getBackgroundColor() {
    return _isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
  }
}
