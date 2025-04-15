import 'package:flutter/material.dart';
import 'theme_manager.dart';

// This extension allows easy access to ThemeManager from BuildContext
extension ThemeExtension on BuildContext {
  ThemeManager get themeManager => ThemeManager();

  // Quick access to common theme colors
  Color get backgroundColor => themeManager.backgroundColor;
  Color get cardColor => themeManager.cardColor;
  Color get primaryTextColor => themeManager.primaryTextColor;
  Color get secondaryTextColor => themeManager.secondaryTextColor;
  bool get isDarkMode => themeManager.isDarkMode;
}

// Extension to make it easy to add ThemeManager awareness to any widget
extension ThemeAwareWidget on Widget {
  Widget withThemeListener(Function setState) {
    final themeManager = ThemeManager();
    themeManager.addListener(() {
      setState();
    });
    return this;
  }
}