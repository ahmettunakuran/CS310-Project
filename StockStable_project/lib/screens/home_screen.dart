import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: SizedBox(
          height: 40,
          child: TextField(
            style: const TextStyle(fontSize: 14.0),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              hintText: 'Search...',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chart Placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 35, 91, 131),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                child: Text(
                  'Chart Placeholder',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Out of Stock Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Out Of Stock',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/outOfStock');
                  },
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              elevation: 2,
              child: const ListTile(
                title: Text('Product Name'),
                subtitle: Text('ProductNo • Price'),
              ),
            ),
            const SizedBox(height: 20),

            // Stock Information Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stock Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/stockInfo');
                  },
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              elevation: 2,
              child: const ListTile(
                title: Text('Product Name'),
                subtitle: Text('ProductNo • Stock Status'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Add Item button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/addItem');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const StadiumBorder(),
                  backgroundColor: const Color.fromARGB(255, 24, 132, 221),
                ),
                child: const Text('Add Item',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 8),
            // Barcode Scanner button
            FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/barcodeScanner');
              },
              backgroundColor: Colors.yellow.shade700,
              child: const Icon(Icons.qr_code, color: Colors.black),
            ),
            const SizedBox(width: 8),
            // Delete Item button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/deleteProduct');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const StadiumBorder(),
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Delete Item',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
