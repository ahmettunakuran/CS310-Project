import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_padding.dart';
import '../utils/text_styles.dart';

class EditProductScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> product;

  const EditProductScreen({
    super.key,
    required this.docId,
    required this.product,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController nameController;
  late TextEditingController amountController;
  late TextEditingController priceController;

  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection('products');

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product['name']);
    amountController =
        TextEditingController(text: widget.product['amount'].toString());
    priceController =
        TextEditingController(text: widget.product['price'].toString());
  }

  Future<void> _updateProduct() async {
    try {
      await productsRef.doc(widget.docId).update({
        'name': nameController.text.trim(),
        'amount': int.parse(amountController.text.trim()),
        'price': double.parse(priceController.text.trim()),
      });

      Navigator.pop(context); // Go back to Inventory screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product', style: AppTextStyles.appBarText),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Padding(
        padding: AppPadding.all16,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextFormField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price (₺)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
              ),
              child: const Text('Update', style: AppTextStyles.buttonText),
            )
          ],
        ),
      ),
    );
  }
}
