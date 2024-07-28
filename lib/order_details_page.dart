import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;

  OrderDetailsPage({required this.orderId});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  String? _status;
  final List<String> _statuses = ['Pending', 'Processing', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('orders').doc(widget.orderId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Order not found'));
          }

          final order = snapshot.data!;
          _status = order['status'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Product: ${order['product']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8.0),
                Text('Quantity: ${order['quantity']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8.0),
                Text('Status: ${order['status']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8.0),
                DropdownButtonFormField<String>(
                  value: _status,
                  onChanged: (value) {
                    setState(() {
                      _status = value;
                    });
                  },
                  items: _statuses.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Update Status'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('orders').doc(widget.orderId).update({
                      'status': _status,
                    }).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Order status updated')),
                      );
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Update Status'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
