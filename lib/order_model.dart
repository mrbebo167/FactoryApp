import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String id;
  String customerId;
  String status;
  String email;
  String productName; // Add any other fields as required
  int quantity;
  double price;

  Order({
    required this.id,
    required this.customerId,
    required this.status,
    required this.email,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  factory Order.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      customerId: data['customerId'],
      status: data['status'],
      email: data['email'],
      productName: data['productName'],
      quantity: data['quantity'],
      price: data['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'status': status,
      'email': email,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }
}
