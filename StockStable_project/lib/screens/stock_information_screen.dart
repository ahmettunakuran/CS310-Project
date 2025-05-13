import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../models/product.dart';

import 'package:navigate_screens/utils/app_colors.dart';
import 'package:navigate_screens/utils/text_styles.dart';
import '../utils/app_padding.dart';
import '../utils/theme_manager.dart';

class StockInformationScreen extends StatefulWidget {
  const StockInformationScreen({super.key});

  @override
  State<StockInformationScreen> createState() => _StockInformationScreenState();
}

class _StockInformationScreenState extends State<StockInformationScreen> {
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // ProductProvider null olabilir (kullanıcı oturum açıncaya dek)
    final ProductProvider? provider = context.watch<ProductProvider?>();

    return Scaffold(
      backgroundColor: _themeManager.isDarkMode
          ? _themeManager.backgroundColor
          : AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text("Stock Information", style: AppTextStyles.appBarText),
      ),

      /* ─────────────  BODY  ───────────── */
      body: provider == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<Product>>(
        // Sadece stokta ürünleri (amount > 0) filtrele
        stream: provider.products
            .map((list) => list.where((p) => p.amount > 0).toList()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: AppTextStyles.hint));
          }

          final inStock = snapshot.data ?? [];

          if (inStock.isEmpty) {
            return const Center(
              child:
              Text("No products in stock.", style: AppTextStyles.hint),
            );
          }

          return ListView.builder(
            padding: AppPadding.all8,
            itemCount: inStock.length,
            itemBuilder: (_, i) {
              final p = inStock[i];
              return Card(
                margin: AppPadding.cardMargin,
                color: _themeManager.isDarkMode
                    ? _themeManager.cardColor
                    : Colors.white,
                child: ListTile(
                  title: Text(p.name,
                      style:
                      TextStyle(color: _themeManager.primaryTextColor)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product ID: ${p.id}",
                        style: TextStyle(
                            color: _themeManager.secondaryTextColor),
                      ),
                      Text(
                        "Stock Amount: ${p.amount}",
                        style: TextStyle(
                            color: _themeManager.secondaryTextColor),
                      ),
                      Text(
                        "Price: ₺${p.price.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: _themeManager.secondaryTextColor),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
