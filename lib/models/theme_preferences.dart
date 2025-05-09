import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const themeKey = 'theme_mode';
  
  late SharedPreferences _preferences;
  
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }
  
  ThemeMode getThemeMode() {
    final themeIndex = _preferences.getInt(themeKey);
    if (themeIndex == null) return ThemeMode.system;
    return ThemeMode.values[themeIndex];
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    await _preferences.setInt(themeKey, mode.index);
  }
}