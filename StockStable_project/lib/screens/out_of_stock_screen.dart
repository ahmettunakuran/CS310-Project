import 'package:flutter/material.dart';
import 'package:navigate_screens/utils/app_colors.dart';
import 'package:navigate_screens/utils/text_styles.dart';
import '../utils/app_padding.dart';

class OutOfStockScreen extends StatelessWidget {
  const OutOfStockScreen({super.key});

  final List<Map<String, String>> outOfStockProducts = const [
    {"name": "Product A", "number": "0001", "price": "\$15"},
    {"name": "Product C", "number": "0016", "price": "\$300"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
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
            child: ListTile(
              title: Text(product["name"]!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Number: ${product["number"]}"),
                  Text("Price: ${product["price"]}"),
                ],
              ),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: Container(
        color: AppColors.backgroundWhite,
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
