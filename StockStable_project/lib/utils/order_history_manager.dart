import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderHistoryManager {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Delete all order history entries for a specific product
  static Future<void> deleteOrderHistoryForProduct(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Get reference to user's orders collection
    final ordersRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders');

    // Query for all orders with the specified productId
    final querySnapshot = await ordersRef
        .where('productId', isEqualTo: productId)
        .get();

    // Use a batch to delete all matching documents
    final batch = _firestore.batch();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Commit the batch
    await batch.commit();
  }

  // Update product name in all order history entries
  static Future<void> updateProductNameInOrderHistory(
      String productId, String newName) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Get reference to user's orders collection
    final ordersRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders');

    // Query for all orders with the specified productId
    final querySnapshot = await ordersRef
        .where('productId', isEqualTo: productId)
        .get();

    // Use a batch to update all matching documents
    final batch = _firestore.batch();
    for (var doc in querySnapshot.docs) {
      batch.update(doc.reference, {'productName': newName});
    }

    // Commit the batch
    await batch.commit();
  }

  // Check if a product exists in the database
  static Future<bool> productExists(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final docSnap = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('products')
        .doc(productId)
        .get();

    return docSnap.exists;
  }
}