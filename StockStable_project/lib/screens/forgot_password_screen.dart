import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../utils/app_padding.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Padding(
        padding: AppPadding.screenPadding,
        child: ListView(
          children: [
            const SizedBox(height: 60),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.home, color: AppColors.primaryBlue),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
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
            _buildLabelAndField('NEW PASSWORD', '......', obscure: true),
            _buildLabelAndField('PASSWORD AGAIN', '......', obscure: true),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: AppPadding.vertical12,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Confirm Your Password',
                    style: AppTextStyles.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelAndField(String label, String hint,
      {bool obscure = false}) {
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
