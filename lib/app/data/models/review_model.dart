class ReviewModel {
  final String id;
  final String user;
  final double rating;
  final String comment;
  final String date;
  final String productId;

  const ReviewModel({
    required this.id,
    required this.user,
    required this.rating,
    required this.comment,
    required this.date,
    required this.productId,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> m) => ReviewModel(
        id: m['id'] as String,
        user: m['user'] as String,
        rating: (m['rating'] as num).toDouble(),
        comment: m['comment'] as String,
        date: m['date'] as String,
        productId: m['productId'] as String,
      );
}
