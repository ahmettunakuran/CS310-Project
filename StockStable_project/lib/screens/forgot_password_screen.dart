

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../utils/app_padding.dart';
import '../utils/theme_manager.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _showInvalidFormDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _themeManager.isDarkMode ? _themeManager.cardColor : Colors.white,
        title: Text('Invalid Form',
          style: TextStyle(color: _themeManager.primaryTextColor),
        ),
        content: Text('Please enter matching passwords.',
          style: TextStyle(color: _themeManager.primaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK',
              style: TextStyle(color: _themeManager.isDarkMode ? Colors.lightBlue : AppColors.primaryBlue),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeManager.isDarkMode ? _themeManager.backgroundColor : AppColors.backgroundWhite,
      body: Padding(
        padding: AppPadding.screenPadding,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 60),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.home,
                      color: _themeManager.isDarkMode ? Colors.lightBlue : AppColors.primaryBlue
                  ),
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                ),
              ),
              const SizedBox(height: 24),
              Text('ENTER THE CODE',
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
              _buildLabelAndField(
                  'NEW PASSWORD',
                  '......',
                  obscure: true,
                  controller: _newPasswordController,
                  validator: (val) {
                    if (val == null || val.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  }
              ),
              _buildLabelAndField(
                  'PASSWORD AGAIN',
                  '......',
                  obscure: true,
                  controller: _confirmPasswordController,
                  validator: (val) {
                    if (val != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  }
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: AppPadding.vertical12,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushReplacementNamed(context, '/login');
                    } else {
                      _showInvalidFormDialog();
                    }
                  },
                  child: Text('Confirm Your Password', style: AppTextStyles.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelAndField(
      String label,
      String hint, {
        bool obscure = false,
        required TextEditingController controller,
        String? Function(String?)? validator,
      }
      ) {
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
          padding: AppPadding.horizontal16,
          child: TextFormField(
            obscureText: obscure,
            controller: controller,
            validator: validator,
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
              errorStyle: TextStyle(
                color: _themeManager.isDarkMode ? Colors.redAccent : Colors.red,
              ),
            ),
            style: TextStyle(
              fontSize: 12,
              color: _themeManager.primaryTextColor,
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