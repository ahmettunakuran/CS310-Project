import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Order {
  final String id;
  final DateTime date;
  final String productName;
  final int amount;
  final String operationType; // 'add', 'delete', 'stock_increase', 'stock_decrease'
  final int? stockChange; // For stock updates, how much it changed

  Order({
    required this.id,
    required this.date,
    required this.productName,
    required this.amount,
    required this.operationType,
    this.stockChange,
  });

  factory Order.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Order(
      id: doc.id,
      date: (d['date'] as Timestamp).toDate(),
      productName: d['productName'],
      amount: d['amount'],
      operationType: d['operationType'] ?? 'add',
      stockChange: d['stockChange'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'productName': productName,
      'amount': amount,
      'operationType': operationType,
      'stockChange': stockChange,
    };
  }
}

class OrderProvider extends ChangeNotifier {
  OrderProvider({required this.uid}) {
    if (uid.isNotEmpty) _listen();
  }

  final String uid;
  late final Stream<List<Order>> orders = _orderStream;

  Future<void> addOrder(Order order) async {
    if (uid.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('orders')
        .add(order.toMap());
  }

  Future<void> updateProductName(String oldName, String newName) async {
    if (uid.isEmpty) return;

    final QuerySnapshot ordersQuery = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('orders')
        .where('productName', isEqualTo: oldName)
        .get();

    final batch = FirebaseFirestore.instance.batch();
    for (var doc in ordersQuery.docs) {
      batch.update(doc.reference, {'productName': newName});
    }
    await batch.commit();
  }

  Future<void> deleteProductOrders(String productName) async {
    if (uid.isEmpty) return;

    final QuerySnapshot ordersQuery = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('orders')
        .where('productName', isEqualTo: productName)
        .get();

    final batch = FirebaseFirestore.instance.batch();
    for (var doc in ordersQuery.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

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

  void _listen() => orders.first;
}