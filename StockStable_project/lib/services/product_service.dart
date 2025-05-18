import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

Future<void> addProductToFirestore({
  required String name,
  required int amount,
  required double price,
  required String category,
  String? photoUrl,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('User must be logged in to add products');
  }

  final id = const Uuid().v4();

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('products')
      .doc(id)
      .set({
    'id': id,
    'name': name,
    'amount': amount,
    'price': price,
    'category': category,
    'createdBy': user.uid,
    'createdAt': FieldValue.serverTimestamp(),
    if (photoUrl != null) 'photoUrl': photoUrl,
  });
}

Future<void> updateProductStock({
  required String productId,
  required String productName,
  required int newAmount,
  required int oldAmount,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('User must be logged in to update products');
  }

  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('products')
      .doc(productId)
      .update({
    'amount': newAmount,
    'updatedAt': FieldValue.serverTimestamp(),
  });

  // Create order history entry for stock change
  final stockChange = newAmount - oldAmount;
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('orders')
      .add({
    'date': FieldValue.serverTimestamp(),
    'productName': productName,
    'amount': newAmount,
    'operationType': stockChange > 0 ? 'stock_increase' : 'stock_decrease',
    'stockChange': stockChange.abs(),
  });
}

Future<void> updateProductName({
  required String productId,
  required String newName,
  required String oldName,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('User must be logged in to update products');
  }

  // Update product name
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('products')
      .doc(productId)
      .update({
    'name': newName,
    'updatedAt': FieldValue.serverTimestamp(),
  });

  // Update all order history entries with the new name
  final ordersQuery = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('orders')
      .where('productName', isEqualTo: oldName)
      .get();

  final batch = FirebaseFirestore.instance.batch();
  for (var doc in ordersQuery.docs) {
    batch.update(doc.reference, {'productName': newName});
  }
  await batch.commit();
}

Future<void> deleteProduct({
  required String productId,
  required String productName,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('User must be logged in to delete products');
  }

  // Delete the product
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('products')
      .doc(productId)
      .delete();

  // Get all order history entries for this product
  final orderQuery = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('orders')
      .where('productName', isEqualTo: productName)
      .get();

  // Delete all related order history entries
  final batch = FirebaseFirestore.instance.batch();
  for (var doc in orderQuery.docs) {
    batch.delete(doc.reference);
  }
  await batch.commit();
}

// Function to get products for the current user
Stream<QuerySnapshot> getUserProducts() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception('User must be logged in to view products');
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('products')
      .snapshots();
}
