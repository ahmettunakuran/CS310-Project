import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Order {
  final String id;
  final DateTime date;
  final String productName;
  final int amount;

  Order({
    required this.id,
    required this.date,
    required this.productName,
    required this.amount,
  });

  factory Order.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Order(
      id: doc.id,
      date: (d['date'] as Timestamp).toDate(),
      productName: d['productName'],
      amount: d['amount'],
    );
  }
}

class OrderProvider extends ChangeNotifier {
  OrderProvider({required this.uid}) {
    if (uid.isNotEmpty) _listen();
  }

  final String uid;
  late final Stream<List<Order>> orders = _orderStream;

  /* private */
  late final Stream<List<Order>> _orderStream = uid.isEmpty
      ? const Stream.empty()
      : FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('orders')
      .orderBy('date', descending: true)
      .snapshots()
      .map((q) => q.docs.map(Order.fromDoc).toList());

  void _listen() => orders.first; // tetiklemek için boş
}
