import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:navigate_screens/utils/app_colors.dart';
import 'package:navigate_screens/utils/text_styles.dart';
import 'add_item_screen.dart';
import '../utils/app_padding.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../utils/theme_manager.dart';


class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen> {
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(() {
      if (mounted) setState(() {});
    });
  }

  /*Stream<QuerySnapshot> _getUserProducts() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User must be logged in to view products');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }*/
/*
  Future<void> _deleteProduct(String docId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User must be logged in to delete products');
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
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
  }*/
  Future<void> _deleteProduct(String docId) async {
    try {
      await context.read<ProductProvider>().deleteProduct(docId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e')),
      );
    }
  }

  void _showProductInfo(Product product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product.name, style: AppTextStyles.label),
        content: Text(
          "Amount: ${product.amount}\nPrice: ₺${product.price}",
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
    final nameController = TextEditingController(text: product['name']);
    final amountController = TextEditingController(text: product['amount'].toString());
    final priceController = TextEditingController(text: product['price'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price (₺)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final updatedName = nameController.text.trim();
                final updatedAmount = int.tryParse(amountController.text.trim());
                final updatedPrice = double.tryParse(priceController.text.trim());

                if (updatedName.isNotEmpty && updatedAmount != null && updatedPrice != null) {
                  await context.read<ProductProvider>().updateProduct(
                    docId,
                    name: updatedName,
                    amount: updatedAmount,
                    price: updatedPrice,
                  );

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product updated successfully')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update: $e')),
                );
              }
            },
            child: const Text('Update'),
          ),
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
      setState(() {});
    }
  }

  Future<void> _pickAndUploadPhoto(Product product) async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  await _uploadAndSavePhoto(product, File(pickedFile.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  await _uploadAndSavePhoto(product, File(pickedFile.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadAndSavePhoto(Product product, File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child('product_photos').child(fileName);
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final photoUrl = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(product.createdBy)
          .collection('products')
          .doc(product.id)
          .update({'photoUrl': photoUrl});
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fotoğraf yüklenemedi: $e')),
      );
    }
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: AppPadding.listPadding,
      child: ListTile(
        contentPadding: AppPadding.all16,
        leading: product.photoUrl != null && product.photoUrl!.isNotEmpty
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.photoUrl!,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        )
            : Stack(
          children: [
            Container(
              width: 60,
              height: 60,
              color: AppColors.placeholderGrey,
              child: const Icon(Icons.image, color: AppColors.greyCol),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => _pickAndUploadPhoto(product),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          'Product Name: ${product.name}',
          style: TextStyle(
            fontFamily: 'LibreBaskerville',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _themeManager.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ${product.amount}', style: AppTextStyles.hint),
            Text('Price: ₺${product.price}', style: AppTextStyles.hint),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _deleteProduct(product.id);
                  },
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Delete', style: AppTextStyles.smallButtonWhiteText),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deleteRed,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    _showUpdateDialog({
                      'name':   product.name,
                      'amount': product.amount,
                      'price':  product.price,
                    }, product.id);
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Update', style: AppTextStyles.smallButtonWhiteText),
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

    final ProductProvider? provider = context.watch<ProductProvider?>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("INVENTORY", style: AppTextStyles.appBarText),
        backgroundColor: AppColors.primaryBlue,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(provider?.uid ?? 'YANLIŞ_UID')
            .collection('products')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text("No products yet."));
          }
          // Her dokümanı Product modeline dönüştür
          final products = docs.map((doc) {
            try {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return Product.fromDoc(data);
            } catch (e, st) {
              print('Product.fromDoc error: $e\n$st\ndata: ${doc.data()}');
              return null;
            }
          }).whereType<Product>().toList();
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, i) => _buildProductCard(products[i]),
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
