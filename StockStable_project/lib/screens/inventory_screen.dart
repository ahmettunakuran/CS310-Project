import 'package:flutter/material.dart';
import 'add_item_screen.dart'; // ürün oluşturmak için sayfa
import '../widgets/custom_drawer.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen> {
  static List<Map<String, dynamic>> products = [];

  static void addProduct(Map<String, dynamic> product) {
    products.add(product);
  }

  static List<Map<String, dynamic>> getProducts() => products;

  void _showProductInfo(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product['name']),
        content:
            Text("Amount: ${product['amount']}\nPrice: ₺${product['price']}"),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  Future<void> _navigateToAddItem() async {
    final newProduct = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddItemScreen()),
    );

    if (newProduct != null) {
      setState(() {
        products.add(newProduct as Map<String, dynamic>);
      });
    }
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          color: Colors.grey.shade300,
          child: const Icon(Icons.image, color: Colors.grey),
        ),
        title: Text('Product Name: ${product['name']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ${product['amount']}'),
            Text('Price: ₺${product['price']}'),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/deleteItem');
              },
              icon: const Icon(Icons.delete, size: 16),
              label: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            )
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showProductInfo(product),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(title: const Text("INVENTORY")),
      body: products.isEmpty
          ? const Center(child: Text("No products yet."))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) =>
                  _buildProductCard(products[index], index),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: _navigateToAddItem,
          icon: const Icon(Icons.add),
          label: const Text('Add Item'),
        ),
      ),
    );
  }
}
