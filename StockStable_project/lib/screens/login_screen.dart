import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../utils/theme_manager.dart';
import '../utils/app_padding.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ThemeManager _themeManager = ThemeManager();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        title: const Text('Invalid Form'),
        content: const Text('Please fill all fields correctly.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      body: Padding(
        padding: AppPadding.screenPadding,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 60),
              const SizedBox(height: 20),
              Text(
                'Welcome!',
                style: AppTextStyles.welcome.copyWith(
                  color: _themeManager.primaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                height: 120,
                width: 120,
                color: _themeManager.isDarkMode
                    ? const Color(0xFF404040)
                    : Colors.grey[300],
                alignment: Alignment.center,
                child: Text(
                  'USER PHOTO',
                  style: TextStyle(color: _themeManager.primaryTextColor),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'USERNAME OR EMAIL',
                style: AppTextStyles.label.copyWith(
                  color: _themeManager.primaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              _buildInputField(
                controller: usernameController,
                hint: 'Username..',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your username or email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'PASSWORD',
                style: AppTextStyles.label.copyWith(
                  color: _themeManager.primaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              _buildInputField(
                controller: passwordController,
                hint: '......',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/forgotPassword'),
                  child: Text(
                    'FORGOT YOUR PASSWORD?',
                    style: AppTextStyles.link.copyWith(
                      color: _themeManager.isDarkMode
                          ? Colors.lightBlue
                          : AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: AppPadding.vertical12,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      _showInvalidFormDialog();
                    }
                  },
                  child: Text('Log in', style: AppTextStyles.buttonText),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/signUp'),
                  child: Text(
                    "DON'T HAVE ACCOUNT ?",
                    style: AppTextStyles.link.copyWith(
                      color: _themeManager.isDarkMode
                          ? Colors.lightBlue
                          : AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _themeManager.isDarkMode
            ? const Color(0xFF353535)
            : AppColors.fieldBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: AppPadding.horizontal16,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        autocorrect: false,
        enableSuggestions: false,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.none,
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
          color: _themeManager.primaryTextColor,
        ),
        validator: validator,
      ),
    );
  }
}

