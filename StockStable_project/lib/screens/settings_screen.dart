import 'package:flutter/material.dart';
import '../utils/theme_manager.dart';

// Simple class to store settings in memory during runtime
class AppSettings {
  static bool darkMode = false;
  static bool notifications = false;
  static String language = 'English';
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = false;
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Turkish', 'Spanish', 'French', 'German'];
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    // Load settings from static class
    _darkMode = AppSettings.darkMode;
    _notifications = AppSettings.notifications;
    _selectedLanguage = AppSettings.language;

    // Synchronize with ThemeManager
    _darkMode = _themeManager.isDarkMode;

    // Listen for theme changes
    _themeManager.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Save settings to static class
  void _saveSettings() {
    AppSettings.darkMode = _darkMode;
    AppSettings.notifications = _notifications;
    AppSettings.language = _selectedLanguage;

    // Update ThemeManager when dark mode changes
    _themeManager.toggleTheme(_darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        title: const Text("SETTINGS"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Settings Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.blue,
              alignment: Alignment.center,
              child: const Text(
                'SETTINGS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Dark Mode Toggle
            _buildToggleSetting(
              title: 'Dark mode:',
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                  _saveSettings();
                });
              },
            ),

            // Notifications Toggle
            _buildToggleSetting(
              title: 'Notifications:',
              value: _notifications,
              onChanged: (value) {
                setState(() {
                  _notifications = value;
                  _saveSettings();
                });
              },
            ),

            // Language Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Language:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _themeManager.primaryTextColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: _themeManager.isDarkMode ? Color(0xFF353535) : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedLanguage,
                      underline: const SizedBox(),
                      dropdownColor: _themeManager.isDarkMode ? Color(0xFF353535) : Colors.grey.shade300,
                      style: TextStyle(color: _themeManager.primaryTextColor),
                      icon: Icon(Icons.arrow_drop_down, color: _themeManager.primaryTextColor),
                      items: _languages.map((String language) {
                        return DropdownMenuItem<String>(
                          value: language,
                          child: Text(language),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedLanguage = newValue;
                            _saveSettings();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // User Info Section
            _buildInfoSection(
              title: 'USER INFO',
              children: [
                _buildInfoItem(
                  color: _themeManager.infoOddColor,
                  text: 'Username: user123',
                ),
                _buildInfoItem(
                  color: _themeManager.infoEvenColor,
                  text: 'Email: user@example.com',
                ),
                _buildInfoItem(
                  color: _themeManager.infoOddColor,
                  text: 'Phone: XXX-XXX-XX-XX',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Company Info Section
            _buildInfoSection(
              title: 'COMPANY INFO',
              children: [
                _buildInfoItem(
                  color: _themeManager.infoOddColor,
                  text: 'StockStable App v1.0.0',
                ),
                _buildInfoItem(
                  color: _themeManager.infoEvenColor,
                  text: 'Developed by CS310 Team',
                ),
                _buildInfoItem(
                  color: _themeManager.infoOddColor,
                  text: 'Support: 0@sabanciuniv.edu',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSetting({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _themeManager.primaryTextColor,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.blue,
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildInfoItem({
    required Color color,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: color,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _themeManager.primaryTextColor,
        ),
      ),
    );
  }
}