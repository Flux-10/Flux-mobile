import 'package:flutter/material.dart';
import 'package:flux/core/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeMode {
  dark,
  light,
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _currentTheme = ThemeMode.dark;
  static const String _themePreferenceKey = 'theme_mode';

  ThemeProvider() {
    _loadThemeFromPreferences();
  }

  ThemeMode get currentTheme => _currentTheme;
  
  bool get isDarkMode => _currentTheme == ThemeMode.dark;

  // Initialize theme colors based on saved preferences
  Future<void> _loadThemeFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themePreferenceKey);
      
      if (savedTheme != null) {
        _currentTheme = ThemeMode.values.firstWhere(
          (theme) => theme.name == savedTheme,
          orElse: () => ThemeMode.dark,
        );
        _updateColors();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
    }
  }

  // Save theme preference
  Future<void> _saveThemeToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePreferenceKey, _currentTheme.name);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  // Update the static color variables in AppConstants
  void _updateColors() {
    if (_currentTheme == ThemeMode.light) {
      AppConstants.outlinebg = AppConstants.light_outlinebg;
      AppConstants.primarybg = AppConstants.light_primarybg;
      AppConstants.labelText = AppConstants.light_labelText;
      AppConstants.primary = AppConstants.light_primary;
      AppConstants.bg = AppConstants.light_bg;
      AppConstants.onBoard1 = AppConstants.light_onBoard1;
    } else {
      AppConstants.outlinebg = AppConstants.dark_outlinebg;
      AppConstants.primarybg = AppConstants.dark_primarybg;
      AppConstants.labelText = AppConstants.dark_labelText;
      AppConstants.primary = AppConstants.dark_primary;
      AppConstants.bg = AppConstants.dark_bg;
      AppConstants.onBoard1 = AppConstants.dark_onBoard1;
    }
  }

  // Toggle between dark and light themes
  void toggleTheme() {
    _currentTheme = _currentTheme == ThemeMode.dark 
        ? ThemeMode.light 
        : ThemeMode.dark;
    
    _updateColors();
    _saveThemeToPreferences();
    notifyListeners();
  }

  // Set specific theme
  void setTheme(ThemeMode theme) {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      _updateColors();
      _saveThemeToPreferences();
      notifyListeners();
    }
  }
} 