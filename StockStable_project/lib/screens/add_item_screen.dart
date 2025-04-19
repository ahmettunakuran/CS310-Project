// lib/screens/add_item_screen.dart
import 'package:flutter/material.dart';
import 'package:navigate_screens/utils/app_colors.dart';
import '../utils/app_padding.dart';
import 'inventory_screen.dart';

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final stock = int.tryParse(_stockController.text) ?? 0;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final category = _categoryController.text;

      final newProduct = {
        'name': name,
        'amount': stock,
        'price': price,
        'category': category,
      };
      InventoryScreenState.addProduct(newProduct);
      Navigator.pop(context, newProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Item")),
      body: SingleChildScrollView(
        padding: AppPadding.all20,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.placeholderGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.add_photo_alternate,
                      size: 50, color: AppColors.greyCol),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Enter the stock'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Stok girin' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(labelText: 'Enter the product name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ürün adı girin' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration:
                    const InputDecoration(labelText: 'Enter the category'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration:
                    const InputDecoration(labelText: 'Enter the price (₺)'),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
