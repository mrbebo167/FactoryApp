import 'package:cloud_firestore/cloud_firestore.dart';
import 'review_model.dart';

class ReviewService {
  final CollectionReference _reviewCollection = FirebaseFirestore.instance.collection('reviews');

  Future<void> writeReview(Review review) async {
    await _reviewCollection.add(review.toMap());
  }
}
