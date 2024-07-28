import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback logout;

  ProfilePage({required this.logout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data != null) {
            // Ensure the correct casting
            var userData = snapshot.data!.data() as Map<String, dynamic>?;
            if (userData == null) {
              return Center(child: Text("User data not found"));
            }

            // Handle profile picture casting
            var profilePicture = userData['profilePicture'] as String?;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: (profilePicture != null && profilePicture.isNotEmpty)
                          ? NetworkImage(profilePicture)
                          : AssetImage('assets/placeholder.png') as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text("First Name: ${userData['firstName']}", style: TextStyle(fontSize: 18, color: Colors.white)),
                  SizedBox(height: 8.0),
                  Text("Last Name: ${userData['lastName']}", style: TextStyle(fontSize: 18, color: Colors.white)),
                  SizedBox(height: 8.0),
                  Text("Email: ${userData['email']}", style: TextStyle(fontSize: 18, color: Colors.white)),
                  SizedBox(height: 8.0),
                  Text("Role: ${userData['role']}", style: TextStyle(fontSize: 18, color: Colors.white)),
                  SizedBox(height: 8.0),
                  Text("Number of Orders: ${userData['numberOfOrders']}", style: TextStyle(fontSize: 18, color: Colors.white)),
                  SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: logout,
                      child: Text('Logout'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading user data"));
          } else {
            return Center(child: Text("User data not found"));
          }
        },
      ),
    );
  }
}
