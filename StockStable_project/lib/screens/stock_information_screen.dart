import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    return Scaffold(
      backgroundColor: _themeManager.isDarkMode
          ? _themeManager.backgroundColor
          : AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text(
          "Stock Information",
          style: AppTextStyles.appBarText,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('amount', isGreaterThan: 0) // 🔍 Only in-stock items
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data."));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return const Center(
              child: Text("No products in stock.", style: AppTextStyles.hint),
            );
          }

          return ListView.builder(
            padding: AppPadding.all8,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final data = products[index].data() as Map<String, dynamic>;

              return Card(
                margin: AppPadding.cardMargin,
                color: _themeManager.isDarkMode
                    ? _themeManager.cardColor
                    : Colors.white,
                child: ListTile(
                  title: Text(
                    data["name"] ?? '',
                    style: TextStyle(color: _themeManager.primaryTextColor),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product No: ${data["number"] ?? ''}",
                        style:
                            TextStyle(color: _themeManager.secondaryTextColor),
                      ),
                      Text(
                        "Stock Status: ${data["amount"]}",
                        style:
                            TextStyle(color: _themeManager.secondaryTextColor),
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
