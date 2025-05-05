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
  if (user == null) return;

  final id = const Uuid().v4();

  await FirebaseFirestore.instance.collection('products').doc(id).set({
    'id': id,
    'name': name,
    'amount': amount,
    'price': price,
    'category': category,
    'createdBy': user.uid,
    'createdAt': FieldValue.serverTimestamp(),
  });
}
