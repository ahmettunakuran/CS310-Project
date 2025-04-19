import 'package:flutter/material.dart';
import 'package:navigate_screens/utils/app_colors.dart';
import '../utils/theme_manager.dart';
import '../utils/app_padding.dart';

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
  final List<String> _languages = [
    'English',
    'Turkish',
    'Spanish',
    'French',
    'German'
  ];
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    _darkMode = AppSettings.darkMode;
    _notifications = AppSettings.notifications;
    _selectedLanguage = AppSettings.language;
    _darkMode = _themeManager.isDarkMode;

    _themeManager.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _saveSettings() {
    AppSettings.darkMode = _darkMode;
    AppSettings.notifications = _notifications;
    AppSettings.language = _selectedLanguage;
    _themeManager.toggleTheme(_darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        title: const Text("SETTINGS"),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: AppPadding.all16,
              color: AppColors.primaryBlue,
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
            Padding(
              padding: AppPadding.horizontal20.add(AppPadding.vertical16),
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
                    padding: AppPadding.horizontal16,
                    decoration: BoxDecoration(
                      color: _themeManager.isDarkMode
                          ? const Color(0xFF353535)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedLanguage,
                      underline: const SizedBox(),
                      dropdownColor: _themeManager.isDarkMode
                          ? const Color(0xFF353535)
                          : Colors.grey.shade300,
                      style: TextStyle(color: _themeManager.primaryTextColor),
                      icon: Icon(Icons.arrow_drop_down,
                          color: _themeManager.primaryTextColor),
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
            _buildInfoSection(
              title: 'USER INFO',
              children: [
                _buildInfoItem(
                    text: 'Username: user123',
                    color: _themeManager.infoOddColor),
                _buildInfoItem(
                    text: 'Email: user@example.com',
                    color: _themeManager.infoEvenColor),
                _buildInfoItem(
                    text: 'Phone: XXX-XXX-XX-XX',
                    color: _themeManager.infoOddColor),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoSection(
              title: 'COMPANY INFO',
              children: [
                _buildInfoItem(
                    text: 'StockStable App v1.0.0',
                    color: _themeManager.infoOddColor),
                _buildInfoItem(
                    text: 'Developed by CS310 Team',
                    color: _themeManager.infoEvenColor),
                _buildInfoItem(
                    text: 'Support: 0@sabanciuniv.edu',
                    color: _themeManager.infoOddColor),
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
      padding: AppPadding.horizontal20.add(AppPadding.vertical16),
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
            activeColor: AppColors.primaryBlue,
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
          padding: AppPadding.all16,
          color: AppColors.primaryBlue,
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
      padding: AppPadding.all16,
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
