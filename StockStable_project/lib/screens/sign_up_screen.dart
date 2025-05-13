import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../utils/app_padding.dart';
import '../utils/theme_manager.dart';
import '../providers/auth_provider.dart' as my;
import 'package:provider/provider.dart';

// Firebase import stays as‑is
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();
  final _phoneController = TextEditingController();
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
            style: TextStyle(color: _themeManager.primaryTextColor)),
        content: Text('Please fill all fields correctly.',
            style: TextStyle(color: _themeManager.primaryTextColor)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK',
                style: TextStyle(
                    color: _themeManager.isDarkMode
                        ? Colors.lightBlue
                        : AppColors.primaryBlue)),
          )
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _themeManager.isDarkMode ? _themeManager.cardColor : Colors.white,
        title: Text('Error', style: TextStyle(color: _themeManager.primaryTextColor)),
        content: Text(message, style: TextStyle(color: _themeManager.primaryTextColor)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: _themeManager.isDarkMode ? Colors.lightBlue : AppColors.primaryBlue)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeManager.isDarkMode
          ? _themeManager.backgroundColor
          : AppColors.backgroundWhite,
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
                      color: _themeManager.isDarkMode
                          ? Colors.lightBlue
                          : AppColors.primaryBlue),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                ),
              ),
              const SizedBox(height: 24),
              _buildLabelAndField('EMAIL ADDRESS', 'example@mail.com',
                  controller: _emailController, validator: (val) {
                    if (val == null || val.isEmpty || !val.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  }),
              _buildLabelAndField('USERNAME', 'Username..',
                  controller: _usernameController, validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  }),
              _buildLabelAndField('PASSWORD', '......',
                  obscure: true,
                  controller: _passwordController,
                  validator: (val) {
                    if (val == null || val.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  }),
              _buildLabelAndField('PASSWORD AGAIN', '......',
                  obscure: true,
                  controller: _passwordAgainController,
                  validator: (val) {
                    if (val != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  }),
              _buildLabelAndField('PHONE NUMBER', '05xx xxx xx xx',
                  controller: _phoneController, validator: (val) {
                    if (val == null || val.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  }),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: AppPadding.vertical16,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await context.read<my.AuthProvider>().signUp(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          username: _usernameController.text.trim(),
                          phone: _phoneController.text.trim(),
                        );
                        // SplashScreen yönlendiriyorsa aşağıdaki satırı silebilirsiniz
                        Navigator.pushReplacementNamed(context, '/home');
                      } catch (e) {
                        _showErrorDialog(e.toString());
                      }
                    } else {
                      _showInvalidFormDialog();
                    }
                  },
                  child: Text('Sign in', style: AppTextStyles.buttonText),
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
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            AppTextStyles.label.copyWith(color: _themeManager.primaryTextColor)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _themeManager.isDarkMode
                ? const Color(0xFF353535)
                : AppColors.fieldBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: AppPadding.horizontal16,
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            enableSuggestions: true,
            autocorrect: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: _themeManager.isDarkMode
                    ? Colors.grey[400]
                    : Colors.grey[600],
                fontSize: 12,
              ),
              errorStyle: TextStyle(
                color: _themeManager.isDarkMode
                    ? Colors.redAccent
                    : Colors.red,
              ),
            ),
            style: TextStyle(
              fontSize: 12,
              color: _themeManager.primaryTextColor,
            ),
            validator: validator,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
