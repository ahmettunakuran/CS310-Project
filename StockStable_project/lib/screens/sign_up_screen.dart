import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.fieldBackground,
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
            ),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

