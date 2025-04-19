import 'package:flutter/material.dart';
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

  final List<Map<String, String>> outOfStockProducts = const [
    {"name": "Product A", "number": "0001", "price": "\$15"},
    {"name": "Product C", "number": "0016", "price": "\$300"},
  ];

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
      backgroundColor: _themeManager.isDarkMode ? _themeManager.backgroundColor : AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text(
          "Out of Stock Items",
          style: AppTextStyles.appBarText,
        ),
      ),
      body: ListView(
        padding: AppPadding.all8,
        children: outOfStockProducts.map((product) {
          return Card(
            margin: AppPadding.cardMargin,
            color: _themeManager.isDarkMode ? _themeManager.cardColor : Colors.white,
            child: ListTile(
              title: Text(
                product["name"]!,
                style: TextStyle(color: _themeManager.primaryTextColor),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Number: ${product["number"]}",
                    style: TextStyle(color: _themeManager.secondaryTextColor),
                  ),
                  Text(
                    "Price: ${product["price"]}",
                    style: TextStyle(color: _themeManager.secondaryTextColor),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: Container(
        color: _themeManager.isDarkMode ? _themeManager.backgroundColor : AppColors.backgroundWhite,
        padding: AppPadding.bottomButton,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/addItem");
          },
          style: ElevatedButton.styleFrom(
            padding: AppPadding.vertical16,
            shape: const StadiumBorder(),
            backgroundColor: AppColors.primaryBlue,
          ),
          child: const Text(
            "Add Item",
            style: AppTextStyles.smallButtonWhiteText,
          ),
        ),
      ),
    );
  }
}