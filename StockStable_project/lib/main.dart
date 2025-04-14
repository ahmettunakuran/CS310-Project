import 'package:flutter/material.dart';
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

void main() {
  runApp(const StockStableApp());
}

class StockStableApp extends StatelessWidget {
  const StockStableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockStable',
      debugShowCheckedModeBanner: false,
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
        '/deleteItem': (context) => const DeleteProductScreen(), // senin özel route’un
        '/deleteProduct': (context) => const InventoryScreen(),   // dikkatli kullan
        '/orderHistory': (context) => const OrderHistoryScreen(),

        // TODO:
        // '/settings': (context) => const SettingsScreen(),
        // '/help': (context) => const HelpScreen(),
        // '/prodcutDetails': (context) => const ProdcutDetailsScreen(),
      },
    );
  }
}

