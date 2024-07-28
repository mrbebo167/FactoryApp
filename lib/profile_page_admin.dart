import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePageAdmin extends StatelessWidget {
  final Function logout;
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  ProfilePageAdmin({
    required this.logout,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Profile not found'));
          }

          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('First Name: ${user['firstName']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8.0),
                Text('Last Name: ${user['lastName']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8.0),
                Text('Email: ${user['email']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () => logout(),
                  child: Text('Logout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
