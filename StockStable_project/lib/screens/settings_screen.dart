import 'package:flutter/material.dart';
import 'package:navigate_screens/utils/app_colors.dart';
import '../utils/theme_manager.dart';
import '../utils/app_padding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  ];
  final ThemeManager _themeManager = ThemeManager();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userEmail = '';
  String _userName = '';
  String _userPhone = '';

  @override
  void initState() {
    super.initState();
    _darkMode = AppSettings.darkMode;
    _notifications = AppSettings.notifications;
    _selectedLanguage = AppSettings.language;
    _darkMode = _themeManager.isDarkMode;
    _loadUserData();

    _themeManager.addListener(() {
      if (mounted) setState(() {});
    });
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email ?? 'No email';
      });

      // Get user data from Firestore
      try {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          setState(() {
            _userName = userData.data()?['username'] ?? 'No username';
            _userPhone = userData.data()?['phone'] ?? 'No phone number';
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
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
                    text: 'Username: $_userName',
                    color: _themeManager.infoOddColor),
                _buildInfoItem(
                    text: 'Email: $_userEmail',
                    color: _themeManager.infoEvenColor),
                _buildInfoItem(
                    text: 'Phone: $_userPhone',
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
