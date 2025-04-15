import 'package:flutter/material.dart';
import 'inventory_screen.dart'; // eklemeyi unutma


class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});\\saas 

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
      final String name = _nameController.text;
      final int stock = int.tryParse(_stockController.text) ?? 0;
      final double price = double.tryParse(_priceController.text) ?? 0.0;
      final String category = _categoryController.text;

      final newProduct = {
        'name': name,
        'amount': stock,
        'price': price,
        'category': category,
      };
      InventoryScreenState.addProduct(newProduct); // 👈 Inventory'e direkt ekle
      Navigator.pop(context, newProduct); // ÜRÜNÜ GERİ GÖNDERİYORUZ
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Item")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.add_photo_alternate,
                      size: 50, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Enter the stock'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Stok girin'
                    : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration:
                const InputDecoration(labelText: 'Enter the product name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ürün adı girin'
                    : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration:
                const InputDecoration(labelText: 'Enter the category'),
              ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
