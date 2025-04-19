// ✅ ForgotPasswordScreen with form validation and alert dialog

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../utils/app_padding.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _showInvalidFormDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Form'),
        content: const Text('Please enter matching passwords.'),
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
              Text('ENTER THE CODE', style: AppTextStyles.label),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (_) => _buildCodeBox()),
              ),
              const SizedBox(height: 32),
              _buildLabelAndField('NEW PASSWORD', '......', obscure: true, controller: _newPasswordController, validator: (val) {
                if (val == null || val.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              }),
              _buildLabelAndField('PASSWORD AGAIN', '......', obscure: true, controller: _confirmPasswordController, validator: (val) {
                if (val != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              }),
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
            ),
            style: const TextStyle(fontSize: 12),
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
        color: AppColors.fieldBackground,
      ),
      child: const Text('-', style: TextStyle(fontSize: 24)),
    );
  }
}
