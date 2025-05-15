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

  Future<void> deleteProduct(String id) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('products')
        .doc(id)
        .delete();
  }
}
