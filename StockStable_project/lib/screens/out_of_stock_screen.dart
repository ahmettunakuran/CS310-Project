import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../models/product.dart';

import 'package:navigate_screens/utils/app_colors.dart';
import 'package:navigate_screens/utils/text_styles.dart';
import '../utils/app_padding.dart';
import '../utils/theme_manager.dart';

class OutOfStockScreen extends StatefulWidget {
  const OutOfStockScreen({super.key});

  @override
  State<OutOfStockScreen> createState() => _OutOfStockScreenState();
}

class _OutOfStockScreenState extends State<OutOfStockScreen> {
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
    // Provider null olabilir; UID gelene kadar bekleriz
    final ProductProvider? provider = context.watch<ProductProvider?>();

    return Scaffold(
      backgroundColor: _themeManager.isDarkMode
          ? _themeManager.backgroundColor
          : AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text("Out of Stock Items", style: AppTextStyles.appBarText),
      ),

      /* ─────────────  BODY  ───────────── */
      body: provider == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<Product>>(
        // yalnızca miktarı 0 olanları filtreliyoruz
        stream: provider.products
            .map((list) => list.where((p) => p.amount == 0).toList()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: AppTextStyles.hint));
          }

          final outOfStock = snapshot.data ?? [];

          if (outOfStock.isEmpty) {
            return const Center(child: Text("No out of stock products."));
          }

          return ListView.builder(
            padding: AppPadding.all8,
            itemCount: outOfStock.length,
            itemBuilder: (_, i) {
              final p = outOfStock[i];

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
                      Text("Number: ${p.id}",
                          style: TextStyle(
                              color: _themeManager.secondaryTextColor)),
                      Text("Price: ₺${p.price.toStringAsFixed(2)}",
                          style: TextStyle(
                              color: _themeManager.secondaryTextColor)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      /* ─────────────  BOTTOM BUTTON  ───────────── */
      bottomNavigationBar: Container(
        color: _themeManager.isDarkMode
            ? _themeManager.backgroundColor
            : AppColors.backgroundWhite,
        padding: AppPadding.bottomButton,
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, "/addItem"),
          style: ElevatedButton.styleFrom(
            padding: AppPadding.vertical16,
            shape: const StadiumBorder(),
            backgroundColor: AppColors.primaryBlue,
          ),
          child:
          const Text("Add Item", style: AppTextStyles.smallButtonWhiteText),
        ),
      ),
    );
  }
}
