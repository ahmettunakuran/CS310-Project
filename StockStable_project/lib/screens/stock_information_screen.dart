import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    final ProductProvider? provider = context.watch<ProductProvider?>();
    print('StockInformationScreen provider uid: ${provider?.uid}');
    return Scaffold(
      backgroundColor: _themeManager.isDarkMode
          ? _themeManager.backgroundColor
          : AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text("Stock Information", style: AppTextStyles.appBarText),
      ),

      /* ─────────────  BODY  ───────────── */
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(provider?.uid ?? 'YANLIŞ_UID')
            .collection('products')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          print('StockInfo direct snapshot: state=${snapshot.connectionState}, hasData=${snapshot.hasData}, error=${snapshot.error}, docs=${snapshot.data?.docs.length}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: AppTextStyles.hint));
          }
          final docs = snapshot.data?.docs ?? [];
          // Her dokümanı Product modeline dönüştür
          final products = docs.map((doc) {
            try {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return Product.fromDoc(data);
            } catch (e, st) {
              print('Product.fromDoc error: $e\n$st\ndata: ${doc.data()}');
              return null;
            }
          }).whereType<Product>().where((p) => p.amount > 0).toList();
          if (products.isEmpty) {
            return const Center(
              child: Text("No products in stock.", style: AppTextStyles.hint),
            );
          }
          return ListView.builder(
            padding: AppPadding.all8,
            itemCount: products.length,
            itemBuilder: (_, i) {
              final p = products[i];
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
