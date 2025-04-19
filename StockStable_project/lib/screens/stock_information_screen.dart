import 'package:flutter/material.dart';
import 'package:navigate_screens/utils/app_colors.dart';
import '../utils/app_padding.dart';

class StockInformationScreen extends StatelessWidget {
  const StockInformationScreen({super.key});

  final List<Map<String, String>> outOfStockProducts = const [
    {"name": "Product A", "number": "0001", "status": "Low on stock"},
    {"name": "Product C", "number": "0016", "status": "Low on stock"},
    {"name": "Product D", "number": "0022", "status": "Low on stock"},
    {"name": "Product E", "number": "0031", "status": "Low on stock"},
    {"name": "Product F", "number": "0044", "status": "Low on stock"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: const Text("Stock Information"),
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
                  Text("Product No: ${product["number"]}"),
                  Text("Stock Status: ${product["status"]}"),
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
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
