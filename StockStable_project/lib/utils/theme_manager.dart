import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  // Singleton pattern
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal();

  // Theme state
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // Get the current theme
  ThemeData get currentTheme => _isDarkMode ? _darkTheme : _lightTheme;

  // Color getters that components can use
  Color get backgroundColor => _isDarkMode ? Colors.grey[900]! : Colors.white;
  Color get cardColor => _isDarkMode ? Colors.grey[800]! : Colors.white;
  Color get primaryTextColor => _isDarkMode ? Colors.white : Colors.black;
  Color get secondaryTextColor => _isDarkMode ? Colors.grey[300]! : Colors.grey[700]!;

  // FAQ colors
  Color get faqOddColor => _isDarkMode ? Color(0xFF3A3A00) : Colors.yellow.shade100;
  Color get faqEvenColor => _isDarkMode ? Color(0xFF2A2A2A) : Colors.grey.shade200;

  // Info section colors
  Color get infoOddColor => _isDarkMode ? Color(0xFF3A3A00) : Colors.yellow.shade100;
  Color get infoEvenColor => _isDarkMode ? Color(0xFF2A2A2A) : Colors.grey.shade200;

  // Define light theme
  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey.shade200,
    ),
  );

  // Define dark theme
  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Color(0xFF2C2C2C),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color(0xFF2A2A2A),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF121212),
    ),
  );

  // List of listeners
  final List<Function> _listeners = [];

  // Add a listener
  void addListener(Function callback) {
    _listeners.add(callback);
  }

  // Remove a listener
  void removeListener(Function callback) {
    _listeners.remove(callback);
  }

  // Notify all listeners
  void notifyListeners() {
    for (var callback in _listeners) {
      callback();
    }
  }

  // Toggle the theme
  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }
}