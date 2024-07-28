import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerProfilePage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  CustomerProfilePage({
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF1F1F1F) : Colors.white,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: isDarkMode ? Colors.black : Colors.yellow,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.yellow : Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: isDarkMode ? Colors.yellow : Colors.black),
            onPressed: () {
              // Navigate to Edit Profile Page (implementation needed)
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No profile data found'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final firstName = userData['firstName'] ?? 'N/A';
          final lastName = userData['lastName'] ?? 'N/A';

          return Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.black : Colors.yellow,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user?.photoURL ?? 'assets\placeholder.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              ListTile(
                leading: Icon(Icons.person, color: isDarkMode ? Colors.yellow : Colors.black),
                title: Text('Name', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                subtitle: Text('$firstName $lastName', style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54)),
              ),
              ListTile(
                leading: Icon(Icons.email, color: isDarkMode ? Colors.yellow : Colors.black),
                title: Text('Email', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                subtitle: Text('${user?.email ?? 'N/A'}', style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54)),
              ),
              Divider(color: isDarkMode ? Colors.white70 : Colors.black54),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Order History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.yellow : Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('userId', isEqualTo: user?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No orders found', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)));
                    }

                    final orders = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return ListTile(
                          title: Text('Order: ${order['product']}', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                          subtitle: Text('Quantity: ${order['quantity']}', style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54)),
                          trailing: Text('Status: ${order['status']}', style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54)),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
