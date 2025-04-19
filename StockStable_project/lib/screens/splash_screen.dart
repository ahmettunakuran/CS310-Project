import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_padding.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Center(
        child: Padding(
          padding: AppPadding.all16,
          child: Image.asset(
            'lib/assets/stock_stable_logo.png',
            width: 200,
          ),
        ),
      ),
    );
  }
}
