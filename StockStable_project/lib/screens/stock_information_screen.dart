import 'package:flutter/material.dart';
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

  final List<Map<String, String>> outOfStockProducts = const [
    {"name": "Product A", "number": "0001", "status": "Low on stock"},
    {"name": "Product C", "number": "0016", "status": "Low on stock"},
    {"name": "Product D", "number": "0022", "status": "Low on stock"},
    {"name": "Product E", "number": "0031", "status": "Low on stock"},
    {"name": "Product F", "number": "0044", "status": "Low on stock"},
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
          "Stock Information",
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
                    "Product No: ${product["number"]}",
                    style: TextStyle(color: _themeManager.secondaryTextColor),
                  ),
                  Text(
                    "Stock Status: ${product["status"]}",
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