class ReviewModel {
  final String id;
  final String userName;
  final String? userAvatarUrl;
  final double rating;
  final String comment;
  final String date;
  final String productId;
  final int helpfulCount;

  const ReviewModel({
    required this.id,
    required this.userName,
    this.userAvatarUrl,
    required this.rating,
    required this.comment,
    required this.date,
    required this.productId,
    this.helpfulCount = 0,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> m) => ReviewModel(
        id: m['id'] as String,
        userName: (m['user'] as String?) ?? (m['userName'] as String?) ?? '',
        userAvatarUrl: m['userAvatarUrl'] as String?,
        rating: (m['rating'] as num).toDouble(),
        comment: (m['comment'] as String?) ?? '',
        date: (m['date'] as String?) ?? '',
        productId: (m['productId'] as String?) ?? '',
      );

  factory ReviewModel.fromJson(Map<String, dynamic> j) => ReviewModel(
        id: j['id'] as String,
        userName: (j['user_name'] as String?) ?? '',
        userAvatarUrl: j['user_avatar_url'] as String?,
        rating: (j['rating'] as num).toDouble(),
        comment: (j['comment'] as String?) ?? '',
        date: (j['date'] as String?) ?? '',
        productId: (j['product_id'] as String?) ?? '',
        helpfulCount: (j['helpful_count'] as int?) ?? 0,
      );
}
