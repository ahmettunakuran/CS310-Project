import 'package:flutter/material.dart';

class StockInformationScreen extends StatelessWidget {
  const StockInformationScreen({super.key});

  final List<Map<String, String>> outOfStockProducts = const [
    {"name": "Product A", "number": "0001", "status": "Low on stock"},
    {"name": "Product C", "number": "0016", "status": "Low on stock"},
    {"name": "Product C", "number": "0016", "status": "Low on stock"},
    {"name": "Product C", "number": "0016", "status": "Low on stock"},
    {"name": "Product C", "number": "0016", "status": "Low on stock"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Stock Information"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: outOfStockProducts.map((product) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
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
        }).toList(), // Converting iterable maps to list
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
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
