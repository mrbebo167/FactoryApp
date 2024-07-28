import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'order_model.dart' as model;

class OrderService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<model.Order>> getOrders() {
    return _db.collection('orders').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => model.Order.fromDocument(doc))
        .toList());
  }

  Stream<List<model.Order>> trackOrders(String customerId) {
    return _db
        .collection('orders')
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => model.Order.fromDocument(doc))
            .toList());
  }

  Future<void> createOrder(model.Order order) {
    var result = _db.collection('orders').add(order.toMap());
    _notifyAdmin(order);  // Notify admin about the new order
    return result;
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) {
    return _db.collection('orders').doc(orderId).update({'status': newStatus});
  }

  Future<void> deleteOrder(String orderId) {
    return _db.collection('orders').doc(orderId).delete();
  }

  void _notifyAdmin(model.Order order) {
    _db.collection('notifications').add({
      'type': 'new_order',
      'message': 'New order placed by ${order.email}',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
