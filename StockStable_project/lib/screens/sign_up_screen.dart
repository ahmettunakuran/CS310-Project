// ✅ SignUpScreen with basic form validation

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../utils/app_padding.dart';

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
      backgroundColor: AppColors.backgroundWhite,
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
                  icon: const Icon(Icons.home, color: AppColors.primaryBlue),
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                ),
              ),
              const SizedBox(height: 24),
              _buildLabelAndField('EMAIL ADDRESS', 'example@mail.com', controller: _emailController, validator: (val) {
                if (val == null || val.isEmpty || !val.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              }),
              _buildLabelAndField('USERNAME', 'Username..', controller: _usernameController, validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              }),
              _buildLabelAndField('PASSWORD', '......', obscure: true, controller: _passwordController, validator: (val) {
                if (val == null || val.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              }),
              _buildLabelAndField('PASSWORD AGAIN', '......', obscure: true, controller: _passwordAgainController, validator: (val) {
                if (val != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              }),
              _buildLabelAndField('PHONE NUMBER', '05xx xxx xx xx', controller: _phoneController, validator: (val) {
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushReplacementNamed(context, '/login');
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

  Widget _buildLabelAndField(String label, String hint, {
    bool obscure = false,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.fieldBackground,
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
            ),
            style: const TextStyle(fontSize: 12),
            validator: validator,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
