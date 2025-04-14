import 'package:flutter/material.dart';

class OutOfStockScreen extends StatelessWidget {
  const OutOfStockScreen({super.key});

  // A sample list of out-of-stock products.
  final List<Map<String, String>> outOfStockProducts = const [
    {"name": "Product A", "number": "0001", "price": "\$15"},
    {"name": "Product C", "number": "0016", "price": "\$300"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Out of Stock Items"),
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
                  Text("Number: ${product["number"]}"),
                  Text("Price: ${product["price"]}"),
                ],
              ),
            ),
          );
        }).toList(),
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
