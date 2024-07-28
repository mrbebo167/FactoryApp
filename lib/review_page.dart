import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'review_service.dart';
import 'review_model.dart';

class ReviewPage extends StatelessWidget {
  final TextEditingController reviewController = TextEditingController();
  final String orderId;

  ReviewPage({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: reviewController,
              decoration: InputDecoration(labelText: 'Review'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final reviewText = reviewController.text;
                final userId = context.read<AuthService>().currentUser?.uid ?? '';
                final review = Review(
                  userId: userId,
                  orderId: orderId,
                  reviewText: reviewText,
                );
                await ReviewService().writeReview(review);
              },
              child: Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}
