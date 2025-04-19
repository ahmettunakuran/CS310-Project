import 'package:flutter/material.dart';
import '../utils/theme_manager.dart';

class OutOfStockScreen extends StatefulWidget {
  const OutOfStockScreen({super.key});

  @override
  State<OutOfStockScreen> createState() => _OutOfStockScreenState();
}

class _OutOfStockScreenState extends State<OutOfStockScreen> {
  final ThemeManager _themeManager = ThemeManager();

  // A sample list of out-of-stock products.
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
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        title: const Text("Out of Stock Items"),
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