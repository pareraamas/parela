class SellerModel {
  final String id;
  final String name;
  final double rating;
  final int productCount;
  final bool verified;
  final String location;
  final String? avatarUrl;
  final String? description;
  final int followerCount;
  final int soldCount;
  final String? responseRate;
  final String? responseTime;

  const SellerModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.productCount,
    required this.verified,
    required this.location,
    this.avatarUrl,
    this.description,
    this.followerCount = 0,
    this.soldCount = 0,
    this.responseRate,
    this.responseTime,
  });

  factory SellerModel.fromMap(Map<String, dynamic> m) => SellerModel(
        id: m['id'] as String,
        name: m['name'] as String,
        rating: (m['rating'] as num).toDouble(),
        productCount: (m['productCount'] as int?) ?? 0,
        verified: (m['verified'] as bool?) ?? false,
        location: (m['location'] as String?) ?? '',
      );

  factory SellerModel.fromJson(Map<String, dynamic> j) => SellerModel(
        id: j['id'] as String,
        name: j['name'] as String,
        rating: (j['rating'] as num? ?? 0).toDouble(),
        productCount: (j['product_count'] as int?) ?? 0,
        verified: (j['verified'] as bool?) ?? false,
        location: (j['location'] as String?) ?? '',
        avatarUrl: j['avatar_url'] as String?,
        description: j['description'] as String?,
        followerCount: (j['follower_count'] as int?) ?? 0,
        soldCount: (j['sold_count'] as int?) ?? 0,
        responseRate: j['response_rate'] as String?,
        responseTime: j['response_time'] as String?,
      );
}
