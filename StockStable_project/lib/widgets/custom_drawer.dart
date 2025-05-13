import 'package:flutter/material.dart';
import 'package:navigate_screens/utils/app_colors.dart';
import 'package:navigate_screens/utils/app_padding.dart';
import 'package:navigate_screens/utils/text_styles.dart';
import '../providers/auth_provider.dart' as my;
import 'package:provider/provider.dart';

// Firebase import stays as‑is
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Home icon (clickable)
            Padding(
              padding: AppPadding.all16,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: Icon(Icons.home, size: 40, color: AppColors.primaryBlue),
              ),
            ),

            const SizedBox(height: 20),

            // Buttons
            _drawerButton(
                context, Icons.inventory_2, 'Inventory', '/inventory'),
            _drawerButton(
                context, Icons.receipt_long, 'Order History', '/orderHistory'),
            _drawerButton(context, Icons.settings, 'Settings', '/settings'),
            _drawerButton(context, Icons.help, 'Help', '/help'),

            const Spacer(),

            // Log Out
            Padding(
              padding: AppPadding.all16,
              child: GestureDetector(
                onTap: () async {
                  await context.read<my.AuthProvider>().signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
                },

                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: AppTextStyles.label,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerButton(
      BuildContext context, IconData icon, String label, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow.shade700,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 12),
              Text(label, style: AppTextStyles.smallButtonBlackText),
            ],
          ),
        ),
      ),
    );
  }
}
