import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';   // Eğer ayrı model dosyanız yoksa oluşturun

class ProductProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid;
  Stream<List<Product>>? _productStream;

  ProductProvider({required this.uid}) {
    print('ProductProvider started for uid: $uid');
    _listenToProducts();
  }

  Stream<List<Product>> get products => _productStream ?? const Stream.empty();

  void _listenToProducts() {
    print('Listening to products for uid: $uid');
    _productStream = _db
        .collection('users')
        .doc(uid)
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      print('Firestore snapshot for uid $uid: ${snap.docs.length} products');
      return snap.docs.map((d) {
        try {
          return Product.fromDoc(d.data()..putIfAbsent('id', () => d.id));
        } catch (e, st) {
          print('Product.fromDoc error: $e\n$st\ndata: \\${d.data()}');
          return null;
        }
      }).whereType<Product>().toList();
    });
  }

  Future<void> addProduct(Product p) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('products')
        .doc(p.id)
        .set(p.toMap());
  }

  Future<void> updateProduct(String id, {
    String? name,
    int? amount,
    double? price,
  }) async {
    // First get the current product data
    final docRef = _db
        .collection('users')
        .doc(uid)
        .collection('products')
        .doc(id);

    final doc = await docRef.get();
    if (!doc.exists) {
      throw Exception('Product not found');
    }

    final currentData = doc.data()!;
    final Map<String, dynamic> updates = {};

    if (name != null && name != currentData['name']) {
      updates['name'] = name;

      // Update product name in order history
      final orderQuery = await _db
          .collection('users')
          .doc(uid)
          .collection('orders')
          .where('productName', isEqualTo: currentData['name'])
          .get();

      final batch = _db.batch();
      for (var doc in orderQuery.docs) {
        batch.update(doc.reference, {'productName': name});
      }
      await batch.commit();
    }

    if (amount != null && amount != currentData['amount']) {
      updates['amount'] = amount;

      // Create order history entry for stock change
      final oldAmount = currentData['amount'] as int;
      final stockChange = amount - oldAmount;

      await _db
          .collection('users')
          .doc(uid)
          .collection('orders')
          .add({
        'date': FieldValue.serverTimestamp(),
        'productName': name ?? currentData['name'],
        'amount': amount,  // This is now the total stock
        'operationType': stockChange > 0 ? 'stock_increase' : 'stock_decrease',
        'stockChange': stockChange.abs(),
        'totalStock': amount,  // Adding explicit total stock field
      });
    }

    if (price != null && price != currentData['price']) {
      updates['price'] = price;
    }

    if (updates.isNotEmpty) {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await docRef.update(updates);
    }
  }

  Future<void> deleteProduct(String id) async {
    // First get the product details to get the name
    final productDoc = await _db
        .collection('users')
        .doc(uid)
        .collection('products')
        .doc(id)
        .get();

    if (!productDoc.exists) {
      throw Exception('Product not found');
    }

    final productData = productDoc.data()!;
    final productName = productData['name'] as String;

    // Delete the product
    await _db
        .collection('users')
        .doc(uid)
        .collection('products')
        .doc(id)
        .delete();

    // Get all order history entries for this product
    final orderQuery = await _db
        .collection('users')
        .doc(uid)
        .collection('orders')
        .where('productName', isEqualTo: productName)
        .get();

    // Delete all related order history entries
    final batch = _db.batch();
    for (var doc in orderQuery.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
