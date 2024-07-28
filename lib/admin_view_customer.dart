import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminViewCustomer extends StatelessWidget {
  final String customerId;

  AdminViewCustomer({required this.customerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(customerId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var customerData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('First Name: ${customerData['firstName']}', style: TextStyle(color: Colors.white)),
                Text('Last Name: ${customerData['lastName']}', style: TextStyle(color: Colors.white)),
                Text('Email: ${customerData['email']}', style: TextStyle(color: Colors.white)),
                Text('Role: ${customerData['role']}', style: TextStyle(color: Colors.white)),
                Text('Number of Orders: ${customerData['numberOfOrders']}', style: TextStyle(color: Colors.white)),
                SizedBox(height: 20),
                Text('Orders:', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .where('customerId', isEqualTo: customerId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      var orders = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          var order = orders[index].data() as Map<String, dynamic>;
                          return ListTile(
                            title: Text('Order ${order['orderId']}', style: TextStyle(color: Colors.white)),
                            subtitle: Text('Status: ${order['status']}', style: TextStyle(color: Colors.white)),
                            trailing: DropdownButton<String>(
                              value: order['status'],
                              items: ['Pending', 'Shipped', 'Delivered'].map((String status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(order['orderId'])
                                    .update({'status': newValue});
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: Color(0xFF131D26),
    );
  }
}
