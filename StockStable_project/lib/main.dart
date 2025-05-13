import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'utils/theme_manager.dart';
import 'screens/home_screen.dart';
import 'screens/out_of_stock_screen.dart';
import 'screens/stock_information_screen.dart';
import 'screens/barcode_scanner_screen.dart';
import 'screens/add_item_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/delete_product_screen.dart';
import 'screens/order_history_screen.dart';
import 'screens/help_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ✅ Web için gerekli
  );
  runApp(const StockStableApp());
}

class StockStableApp extends StatefulWidget {
  const StockStableApp({super.key});

  @override
  State<StockStableApp> createState() => _StockStableAppState();
}

class _StockStableAppState extends State<StockStableApp> {
  // Reference to the theme manager
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    // Add a listener to rebuild when theme changes
    _themeManager.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockStable',
      debugShowCheckedModeBanner: false,
      // Use the theme from ThemeManager
      theme: _themeManager.currentTheme,
      // Force dark mode for all screens
      darkTheme: _themeManager.currentTheme,
      themeMode: _themeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signUp': (context) => const SignUpScreen(),
        '/forgotPassword': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/outOfStock': (context) => const OutOfStockScreen(),
        '/stockInfo': (context) => const StockInformationScreen(),
        '/barcodeScanner': (context) => const BarcodeScannerScreen(),
        '/addItem': (context) => const AddItemScreen(),
        '/inventory': (context) => const InventoryScreen(),
        '/deleteItem': (context) => DeleteProductScreen(),
        '/deleteProduct': (context) => const InventoryScreen(),
        '/orderHistory': (context) => OrderHistoryScreen(),
        '/help': (context) => const HelpScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
      // Use builder to wrap the entire app in a Theme
      builder: (context, child) {
        return Theme(
          data: _themeManager.currentTheme,
          child: child!,
        );
      },
    );
  }
}
