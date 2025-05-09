import 'package:flutter/material.dart';

import '../models/theme_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final ThemePreferences themePreferences;
  late ThemeMode _themeMode;
  
  ThemeProvider(this.themePreferences) {
    _themeMode = themePreferences.getThemeMode();
  }
  
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    await themePreferences.setThemeMode(mode);
    notifyListeners();
  }
  
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}