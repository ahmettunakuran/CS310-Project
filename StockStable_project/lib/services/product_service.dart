import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

Future<void> addProductToFirestore({
  required String name,
  required int amount,
  required double price,
  required String category,
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
  });
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
