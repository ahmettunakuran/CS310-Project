// lib/screens/barcode_scanner_screen.dart
import 'package:flutter/material.dart';
import '../utils/app_padding.dart';

class BarcodeScannerScreen extends StatelessWidget {
  const BarcodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Barcode Scanner")),
      body: Padding(
        padding: AppPadding.all16,
        child: const Center(
          child: Text(
            "Barcode Scanner functionality will be implemented here when learned.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
