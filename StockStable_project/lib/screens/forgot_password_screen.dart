import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../utils/theme_manager.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
            Text(
                'ENTER THE CODE',
                style: AppTextStyles.label.copyWith(
                    color: _themeManager.primaryTextColor
                )
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (_) => _buildCodeBox()),
            ),

            const SizedBox(height: 32),
            _buildLabelAndField('NEW PASSWORD', '......', obscure: true),
            _buildLabelAndField('PASSWORD AGAIN', '......', obscure: true),

            const SizedBox(height: 32),
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
                child: Text('Confirm Your Password', style: AppTextStyles.buttonText),
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

  Widget _buildCodeBox() {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _themeManager.isDarkMode ? Color(0xFF353535) : AppColors.fieldBackground,
      ),
      child: Text(
          '-',
          style: TextStyle(
              fontSize: 24,
              color: _themeManager.primaryTextColor
          )
      ),
    );
  }
}