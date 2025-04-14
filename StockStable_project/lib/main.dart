import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/out_of_stock_screen.dart';
import 'screens/stock_information_screen.dart';
import 'screens/barcode_scanner_screen.dart';
import 'screens/add_item_screen.dart';
import 'screens/inventory_screen.dart';

void main() {
  runApp(const StockStableApp());
}

class StockStableApp extends StatelessWidget {
  const StockStableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockStable',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/outOfStock': (context) => const OutOfStockScreen(),
        '/stockInfo': (context) => const StockInformationScreen(),
        '/barcodeScanner': (context) => const BarcodeScannerScreen(),
        '/addItem': (context) => const AddItemScreen(),
        '/inventory': (context) => const InventoryScreen(),
        // TODO: FURAN: SettingsScreen.dart oluşturup designladıktna sonra sağdaki navigasyonu buraya yapıştırılıcak -> '/settings': (context) => const SettingsScreen(),
        // TODO: OZAN: HelpScreen.dart oluşturup designladıktna sonra sağdaki navigasyonu buraya yapıştırılıcak -> '/help': (context) => const HelpScreen(),
        // TODO: OZAN: ProductDetailsScreen.dart oluşturup designladıktna sonra sağdaki navigasyonu buraya yapıştırılıcak -> '/prodcutDetails': (context) => const ProdcutDetailsScreen(),
        // TODO: TUNA: OrderHistoryScreen.dart oluşturup designladıktna sonra sağdaki navigasyonu buraya yapıştırılıcak -> '/orderHistory': (context) => const OrderHistoryScreen(),
        // TODO: TUNA: DeleteProductScreen.dart oluşturup designladıktna sonra sağdaki navigasyonu buraya yapıştırılıcak -> '/deleteProduct': (context) => const DeleteProductScreen(),
      },
    );
  }
}
