// lib/screens/add_item_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../utils/app_padding.dart';
import '../services/product_service.dart';
import '../providers/order_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _photoUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color hintColor = isDark ? Colors.grey[400]! : Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Item", style: AppTextStyles.appBarText),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: SingleChildScrollView(
        padding: AppPadding.all20,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Stock
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter the stock',
                  labelStyle: AppTextStyles.label.copyWith(color: textColor),
                  hintText: 'Enter the stock',
                  hintStyle: AppTextStyles.hint.copyWith(color: hintColor),
                ),
                style: AppTextStyles.hint.copyWith(color: textColor),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the stock';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid whole number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Product name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Enter the product name',
                  labelStyle: AppTextStyles.label.copyWith(color: textColor),
                  hintText: 'Enter the product name',
                  hintStyle: AppTextStyles.hint.copyWith(color: hintColor),
                ),
                style: AppTextStyles.hint.copyWith(color: textColor),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the product name'
                    : null,
              ),
              const SizedBox(height: 16),

              // Category
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Enter the category',
                  labelStyle: AppTextStyles.label.copyWith(color: textColor),
                  hintText: 'Enter the category',
                  hintStyle: AppTextStyles.hint.copyWith(color: hintColor),
                ),
                style: AppTextStyles.hint.copyWith(color: textColor),
              ),
              const SizedBox(height: 16),

              // Price
              TextFormField(
                controller: _priceController,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Enter the price (₺)',
                  labelStyle: AppTextStyles.label.copyWith(color: textColor),
                  hintText: 'Enter the price (₺)',
                  hintStyle: AppTextStyles.hint.copyWith(color: hintColor),
                ),
                style: AppTextStyles.hint.copyWith(color: textColor),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Photo URL
              TextFormField(
                controller: _photoUrlController,
                decoration: InputDecoration(
                  labelText: 'Photo URL (optional)',
                  labelStyle: AppTextStyles.label.copyWith(color: textColor),
                  hintText: 'https://.../image.jpg',
                  hintStyle: AppTextStyles.hint.copyWith(color: hintColor),
                ),
                style: AppTextStyles.hint.copyWith(color: textColor),
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.add),
                label: const Text('Add', style: AppTextStyles.buttonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      _showValidationDialog();
      return;
    }
    try {
      final name = _nameController.text;
      final stock = int.tryParse(_stockController.text) ?? 0;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final category = _categoryController.text;
      final photoUrl = _photoUrlController.text.isNotEmpty ? _photoUrlController.text : null;

      // Add the product to Firestore
      await addProductToFirestore(
        name: name,
        amount: stock,
        price: price,
        category: category,
        photoUrl: photoUrl,
      );

      // Create order history entry
      final orderProvider = Provider.of<OrderProvider?>(context, listen: false);
      if (orderProvider != null) {
        await orderProvider.addOrder(Order(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: DateTime.now(),
          productName: name,
          amount: stock,
          operationType: 'add',
        ));
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error", style: AppTextStyles.label),
            content: Text(
              e.toString(),
              style: AppTextStyles.hint,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK", style: AppTextStyles.link),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showValidationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Invalid Input", style: AppTextStyles.label),
        content: const Text(
          "Please check your inputs. Make sure stock is a whole number and price is a valid number.",
          style: AppTextStyles.hint,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: AppTextStyles.link),
          ),
        ],
      ),
    );
  }
}
