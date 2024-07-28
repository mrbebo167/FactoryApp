import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_model.dart' as model;

class TrackOrderPage extends StatelessWidget {
  final String customerId;

  TrackOrderPage({required this.customerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Order'),
      ),
      body: StreamBuilder<List<model.Order>>(
        stream: OrderService().trackOrders(customerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('Order ${order.id}'),
                subtitle: Text('Status: ${order.status}'),
              );
            },
          );
        },
      ),
    );
  }
}

class OrderService {
  Stream<List<model.Order>> trackOrders(String customerId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => model.Order.fromDocument(doc)).toList());
  }
}
