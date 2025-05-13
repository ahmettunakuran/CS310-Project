import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection('products');

  Future<void> _deleteProduct(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e')),
      );
    }
  }

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

  void _showUpdateDialog(Map<String, dynamic> product, String docId) {
    final TextEditingController nameController =
        TextEditingController(text: product['name']);
    final TextEditingController amountController =
        TextEditingController(text: product['amount'].toString());
    final TextEditingController priceController =
        TextEditingController(text: product['price'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Product"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Price (₺)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedName = nameController.text.trim();
                final updatedAmount =
                    int.tryParse(amountController.text.trim());
                final updatedPrice =
                    double.tryParse(priceController.text.trim());

                if (updatedName.isNotEmpty &&
                    updatedAmount != null &&
                    updatedPrice != null) {
                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(docId)
                      .update({
                    'name': updatedName,
                    'amount': updatedAmount,
                    'price': updatedPrice,
                  });

                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToAddItem() async {
    final newProduct = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddItemScreen()),
    );

    if (newProduct != null) {
      setState(() {}); // Triggers refresh after adding
    }
  }

  Widget _buildProductCard(Map<String, dynamic> product, String docId) {
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
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _deleteProduct(docId);
                  },
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Delete',
                      style: AppTextStyles.smallButtonWhiteText),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deleteRed,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    _showUpdateDialog(product, docId);
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Update',
                      style: AppTextStyles.smallButtonWhiteText),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonYellow,
                  ),
                ),
              ],
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsRef.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return const Center(
              child: Text("No products yet.", style: AppTextStyles.hint),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final doc = products[index];
              return _buildProductCard(
                  doc.data() as Map<String, dynamic>, doc.id);
            },
          );
        },
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
