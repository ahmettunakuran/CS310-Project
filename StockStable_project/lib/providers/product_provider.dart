import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';   // Eğer ayrı model dosyanız yoksa oluşturun

class ProductProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid;
  Stream<List<Product>>? _productStream;

  ProductProvider({required this.uid}) {
    _listenToProducts();
  }

  Stream<List<Product>> get products => _productStream!;

  void _listenToProducts() {
    _productStream = _db
        .collection('users')
        .doc(uid)
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((d) => Product.fromDoc(d.data()
      ..putIfAbsent('id', () => d.id)))
        .toList());
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
