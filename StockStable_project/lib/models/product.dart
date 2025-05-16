import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final int amount;
  final double price;
  final String category;
  final String createdBy;
  final DateTime? createdAt;
  final String? photoUrl;

  Product({
    required this.id,
    required this.name,
    required this.amount,
    required this.price,
    required this.category,
    required this.createdBy,
    required this.createdAt,
    this.photoUrl,
  });

  /// Firestore belgesinden üret
  factory Product.fromDoc(Map<String, dynamic> data) {
    return Product(
      id: data['id'] as String,
      name: data['name'] as String,
      amount: data['amount'] as int,
      price: (data['price'] as num).toDouble(),
      category: data['category'] as String,
      createdBy: data['createdBy'] as String,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      photoUrl: data['photoUrl'] as String?,
    );
  }

  /// Firestore'a yazarken haritaya dönüştür
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'price': price,
      'category': category,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'photoUrl': photoUrl,
    };
  }
}
