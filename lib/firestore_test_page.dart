import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTestPage extends StatefulWidget {
  @override
  _FirestoreTestPageState createState() => _FirestoreTestPageState();
}

class _FirestoreTestPageState extends State<FirestoreTestPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _message = "Firestore is not connected.";

  @override
  void initState() {
    super.initState();
    _testFirestoreConnection();
  }

  Future<void> _testFirestoreConnection() async {
    try {
      // Write data to Firestore
      await _firestore.collection('test').doc('testDoc').set({
        'message': 'Hello, Firestore!',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Read data from Firestore
      DocumentSnapshot doc = await _firestore.collection('test').doc('testDoc').get();
      if (doc.exists) {
        setState(() {
          _message = doc['message'];
        });
      } else {
        setState(() {
          _message = "No document found.";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Error connecting to Firestore: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Test'),
      ),
      body: Center(
        child: Text(_message),
      ),
    );
  }
}
