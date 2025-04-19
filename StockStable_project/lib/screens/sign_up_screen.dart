import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../utils/theme_manager.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            const SizedBox(height: 60),

            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(
                    Icons.home,
                    color: _themeManager.isDarkMode ? Colors.lightBlue : AppColors.primaryBlue
                ),
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              ),
            ),

            const SizedBox(height: 24),
            _buildLabelAndField('EMAIL ADDRESS', 'example@mail.com'),
            _buildLabelAndField('USERNAME', 'Username..'),
            _buildLabelAndField('PASSWORD', '......', obscure: true),
            _buildLabelAndField('PASSWORD AGAIN', '......', obscure: true),
            _buildLabelAndField('PHONE NUMBER', '05xx xxx xx xx'),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Sign in', style: AppTextStyles.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelAndField(String label, String hint, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            label,
            style: AppTextStyles.label.copyWith(
                color: _themeManager.primaryTextColor
            )
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _themeManager.isDarkMode ? Color(0xFF353535) : AppColors.fieldBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            obscureText: obscure,
            enableSuggestions: true,
            autocorrect: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: _themeManager.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 12,
              ),
            ),
            style: TextStyle(
                fontSize: 12,
                color: _themeManager.primaryTextColor
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}