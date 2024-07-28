class Review {
  final String userId;
  final String orderId;
  final String reviewText;

  Review({
    required this.userId,
    required this.orderId,
    required this.reviewText,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'orderId': orderId,
      'reviewText': reviewText,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      userId: map['userId'],
      orderId: map['orderId'],
      reviewText: map['reviewText'],
    );
  }
}
