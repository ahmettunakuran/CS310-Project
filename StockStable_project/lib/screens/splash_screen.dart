import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthProvider’daki durum
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;

    // Build tamamlandıktan hemen sonra yönlendirme yap
    Future.microtask(() {
      Navigator.pushReplacementNamed(
        context,
        isLoggedIn ? '/home' : '/login',
      );
    });

    // Kullanıcı yönlendirilene kadar basit bir yükleme animasyonu göster
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

