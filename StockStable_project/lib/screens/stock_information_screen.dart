import 'package:flutter/material.dart';
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
    {"name": "Product C", "number": "0016", "status": "Low on stock"},
    {"name": "Product C", "number": "0016", "status": "Low on stock"},
    {"name": "Product C", "number": "0016", "status": "Low on stock"},
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
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        title: const Text("Stock Information"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: outOfStockProducts.map((product) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: _themeManager.cardColor,
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
        }).toList(), // Converting iterable maps to list
      ),
      bottomNavigationBar: Container(
        color: _themeManager.backgroundColor,
        padding: const EdgeInsets.all(18.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, "/addItem");
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: const StadiumBorder(),
            backgroundColor: const Color.fromARGB(255, 24, 132, 221),
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