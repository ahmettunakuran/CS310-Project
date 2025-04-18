import 'package:flutter/material.dart';
import 'package:navigate_screens/utils/app_colors.dart';
import 'package:navigate_screens/utils/text_styles.dart';
import 'add_item_screen.dart';
import '../utils/app_padding.dart';

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
        title: Text(product['name'], style: AppTextStyles.label),
        content: Text(
          "Amount: ${product['amount']}\nPrice: ₺${product['price']}",
          style: AppTextStyles.hint,
        ),
        actions: [
          TextButton(
            child: const Text("Close", style: AppTextStyles.link),
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
      margin: AppPadding.listPadding,
      child: ListTile(
        contentPadding: AppPadding.all16,
        leading: Container(
          width: 60,
          height: 60,
          color: AppColors.placeholderGrey,
          child: const Icon(Icons.image, color: AppColors.greyCol),
        ),
        title: Text(
          'Product Name: ${product['name']}',
          style: AppTextStyles.label,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ${product['amount']}', style: AppTextStyles.hint),
            Text('Price: ₺${product['price']}', style: AppTextStyles.hint),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/deleteItem');
              },
              icon: const Icon(Icons.delete, size: 16),
              label: const Text('Delete', style: AppTextStyles.smallButtonWhiteText),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deleteRed,
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
      appBar: AppBar(
        title: const Text("INVENTORY", style: AppTextStyles.appBarText),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: products.isEmpty
          ? const Center(
        child: Text("No products yet.", style: AppTextStyles.hint),
      )
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) =>
            _buildProductCard(products[index], index),
      ),
      bottomNavigationBar: Padding(
        padding: AppPadding.all16,
        child: ElevatedButton.icon(
          onPressed: _navigateToAddItem,
          icon: const Icon(Icons.add),
          label: const Text('Add Item', style: AppTextStyles.buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}
